library(limma)
library(edgeR)
library(genefilter)
library(ROC)

foos <- vector()

col.names <- c("Locus", "Transcript_ID", "Coding", "Length", "Expressed Fraction", 
               "Expressed Number", "Library Fraction", "Library Number","Sequenced Fraction", "Sequenced Number", "V11", "V12", "V13")

firstfoo <- read.table("foo0.pro" , header = FALSE, sep = "\t", fill = TRUE,col.names=col.names,flush=TRUE)

#Read foo*.pro using read.table:
for (i in 0:19) {
  pro <- paste("foo", i, ".pro", sep = "")
  print(pro)
  foo <- read.table(pro , header = FALSE, sep = "\t", fill = TRUE,col.names=col.names,flush=TRUE)[,10]
  print(length(foo))
  foos <- c(foos, foo[1:dim(firstfoo)[1]])
}

lastfoo <- read.table("foo19.pro" , header = FALSE, sep = "\t", fill = TRUE,col.names=col.names,flush=TRUE)

dim(firstfoo)
dim(lastfoo)

#firstfoo[29173,]

# check to make sure column 2 is the same (transcript name)

#Concatenate each object as rows into a matrix counts
counts <- matrix(foos, nrow = dim(firstfoo[1])[1], ncol = 20)


rownames(counts) <- firstfoo[,2]

# fix the NA
counts[is.na(counts)] <- 0

#Get the ones that are expressed
isexpr <- rowSums(cpm(counts)>1)>=3

table(isexpr)
#FALSE  TRUE 
#9 29164

#Separate the genes that are expressed:
counts <- counts[isexpr,]

ran <- sample(1:sum(isexpr), 2000)

counts[ran[1:500], 11:20] <- counts[ran[1:500], 11:20] + 200
counts[ran[501:1000], 11:20] <- counts[ran[501:1000], 11:20] + 100
counts[ran[1001:1500], 1:10] <- counts[ran[1001:1500], 1:10] + 100
counts[ran[1501:2000], 1:10] <- counts[ran[1501:2000], 1:10] + 200

#Modify the last 10 columns:
# 500 upregulated
#counts[1:500, 11:20] <- counts[1:500, 11:20] + 100
# 500 downregulated
#counts[501:1000, 1:10] <- counts[501:1000, 1:10] + 100

counts[counts < 0] <- 0
#Apply TMM normalization using the edgeR package:
nf <- calcNormFactors(counts)

#VOOM!!!
y <- voom(counts, plot = FALSE, lib.size=colSums(counts)*nf)

#plotMDS(y, top = 500, labels = c(rep("norm", 10), rep("treat", 10)), gene.selection = "common")
groups <- as.factor(c(rep("norm", 10), rep("treat", 10)))
design <- model.matrix(~ 0 + groups)
fit <- lmFit(y,design)
fit <- eBayes(fit)
#options(digits=3)
#topTable(fit,coef=2,n=16)
volcanoplot(fit, coef = 2)

#Make all pair-wise comparisons:
contrasts <- makeContrasts("groupstreat-groupsnorm", levels=design)

fit2 <- contrasts.fit(fit, contrasts)
fit2 <- eBayes(fit2)
#options(digits=3)
#topTable(fit2,coef=1,n=10)
volcanoplot(fit2)

calls <- decideTests(fit2)
table(calls)
#calls
#0     1 
#41984   338

row.index <- 1:length(calls)
#which.rows <- t(calls)
#row.index[t(which.rows != 0)]

### mld
row.means <- rowMeans(y$E)

row.norm.means <- rowMeans(y$E[,1:10])
row.trea.means <- rowMeans(y$E[,11:20])

# center on zero
diffs <- y$E[,11:20] - row.norm.means
row.diff.means <- rowMeans(diffs)
diffs.zero <- diffs - row.diff.means

sds <- rowSds(diffs.zero)

mld <- function(calls.grouped) {
  n = length(calls.grouped)
  maj = ceiling(n/3)
  tab = table(calls.grouped)
  if (tab[1] > maj)
    dimnames(tab)[[1]][1]
  else if (tab[2] > maj)
    dimnames(tab)[[1]][2]
  else if (tab[3] > maj)
    dimnames(tab)[[1]][3]
  else
    "?"
}

#length(sds)

# pick epsilon to be one standard deviation from the mean.
epsilon = 1.3
calls <- (abs(diffs) > (sds * epsilon)) * sign(diffs)
all.calls <- apply(calls, 1, mld)
expressed <- all.calls != "0"

positives <- 2000
tp <- sum(expressed[ran])
fn <- positives - tp 
notexpr <- (rep(TRUE, times = length(expressed)))
notexpr[ran] <- FALSE
negatives <- length(expressed) - 2000
fp <- sum(expressed[notexpr])
tn <- negatives - fp

# what probes have differential expression
#expressed.genes <- apply(expressed, 1, any)
# [1] 12914

# how many probes expressed at each stage
#expressed.stages <- apply(expressed, 2, sum)

#sum(expressed.genes)

truth <- !notexpr
R1 <- rocdemo.sca(truth, fit2$F.p.value)

es <- c()
xs <- c()
ys <- c()
for (epsilon in seq(from=0.1, to=4, by=0.2)) {
  calls <- (abs(diffs) > (sds * epsilon)) * sign(diffs)
  all.calls <- apply(calls, 1, mld)
  expressed <- all.calls != "0"

  positives <- 2000
  tp <- sum(expressed[ran])
  fn <- positives - tp 
  notexpr <- (rep(TRUE, times = length(expressed)))
  notexpr[ran] <- FALSE
  negatives <- length(expressed) - 2000
  fp <- sum(expressed[notexpr])
  tn <- negatives - fp

  es <- c(es, epsilon)
  xs <- c(xs, fp/negatives)
  ys <- c(ys, tp/positives)
  }

#plot(R1)

#lines(xs, ys)
#abline(0,1)

#volcanoplot(fit2[ran, ])

# get recount
gravely <- load("modencode_fly_pooled.RData")
rcounts <- exprs(modencodefly.eset.pooled[,1:20])
nrf <- calcNormFactors(rcounts)
vr <- voom(rcounts,plot=FALSE,lib.size=colSums(rcounts)*nrf)
