MACTEX = /usr/local/texlive/2012/bin/x86_64-darwin
LATEX  = $(MACTEX)/pdflatex
BIBTEX = $(MACTEX)/bibtex
VIEWER = open

all: biocomp-hoz-rnaseq

biocomp-hoz-rnaseq: biocomp-hoz-rnaseq.tex
	$(LATEX) $<
	$(BIBTEX) $@
	$(LATEX) $<
	$(LATEX) $<

biocomp-hoz-rnaseq.tex: biocomp-hoz-rnaseq.Rnw .RData 
	R CMD Sweave $<

.RData: foo.R modencode_fly_pooled.RData foo0.pro
	R CMD BATCH foo.R
#	cp .RData foo.RData

data.stamp: getit
	wget -c -i getit
	touch data.stamp

modencode_fly_pooled.RData: data.stamp

Drosophila_melanogaster.BDGP5.70.gtf.gz: data.stamp

Drosophila_melanogaster.BDGP5.70.gtf: Drosophila_melanogaster.BDGP5.70.gtf.gz
	cp $< foo.gz
	gzip -d foo.gz
	cp foo $@

2L.fa: Drosophila_melanogaster.BDGP5.70.dna.chromosome.2L.fa.gz
	bash fix.sh

Drosophila_melanogaster.BDGP5.70.dna.chromosome.2L.fa.gz: data.stamp

foo0.pro: foo.par 2L.fa Drosophila_melanogaster.BDGP5.70.gtf
	bash flux.sh
