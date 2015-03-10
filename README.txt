#Documentation for the Flux Simulator and how to run it.

1) Download Flux Simulator: http://sammeth.net/confluence/display/SIM/2+-+Download

2) Obtain a .gtf file from whichever genes you wish to find differential expression.

	i.e Drosophila_melanogaster.BDGP5.70.gtf

3) Obtain FASTA files from that species (getit)

	i.e Drosophila_melanogaster.BDGP5.70.dna.chromosome.2L.fa

	If you run a script in the terminal, it's easier to obtain said files.
	Also, be sure that you feed the flux what it is asking:

		i.e NOT Drosophila_melanogaster.BDGP5.70.dna.chromosome.2L.fa
		    YES 2L.fa

	This can also be done with a script (fix.sh)

4) Obtain the .par file:

	./flux-simulator -o > foo.par
	where foo is the name of the file.
	Make sure that you are in the directory of the flux simulator.

5) Set the .par file so that

	REF_FILE_NAME points to the .gtf file

		and

	GEN_DIR points to the directory containing the FASTA files.

6) Now create a shell script to generate an appropiate amount of .pro files (flux.sh)

	The flux simulator pipeline goes as follows:

		-x is for simulated expression
		-l is for library construction
		-s is for sequencing
		-p is used to pass the .par file

			i.e ./flux-simulator -p foo.par -x -l

	Warning: You must follow this pipeline in order. It is strongly adviced
	         to make each procedure at once without any previous files. This could
	         generate some errors.

	Note: -p can be used before or after the (x l s) set. Preferably before.

7) Now that you have obtained all the .pro files you need, you can manipulate, experiment
   or compare datasets using any sort of statistical software. In our case, R (foo.R)

2014/04/02 - HOZ

There are publically available datasets with dmel spike in data

Jiang L, Schlesinger F, Davis CA, Zhang Y et al. Synthetic spike-in
standards for RNA-seq experiments. Genome Res 2011
Sep;21(9):1543-51. PMID: 21816910

RNA-Seq on libraries made from External RNA Controls Consortium (ERCC)
external RNA controls, and a mixture of mRNA from Drosophila
melanogaster S2 cell and ERCC mRNAs.

We evaluated performance of RNA-Seq on known synthetic PolyA+ mRNAs
from the External RNA Controls Consortium (ERCC) alone and in mixtures
with PolyA+ mRNA from Drosophila S2 cells. ERCC mRNAs were obtained
under Phase V testing from the National Institutes of Standards and
Technology (NIST). The ERCC pool contained 96 species of mRNA of
various lengths and GC content covering a 2^20 concentration
range. Libraries were constructed using 100ng S2 mRNA with 5ng, 2.5ng,
or 1ng ERCC mRNAs, and using 50ng ERCC mRNA without S2 cell mRNA. Our
data shows an outstanding linear fit between RNA-Seq read density and
known input amounts.

GSM516588, GSM516589, GSM517059, GSM517060, GSM517061, GSM517062, and
GSE26284.

GSE20579 is 

GSM517059	100ng_S2_5ng_ERCC_phaseV_pool15_mRNA-seq
GSM517060	100ng_S2_2.5ng_ERCC_phaseV_pool15_mRNA-seq
GSM517061	100ng_S2_1ng_ERCC_phaseV_pool15_mRNA
GSM517062	50ng_ERCC_phaseV_pool15_mRNA-seq

http://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE20579&format=file

GSE20555 has dilutions of different runs:

GSM516588	100ng_library_methA_S2_2.5%ERCC_phaseV_pool15mRNA
GSM516589	100ng_library_methB_S2_2.5%ERCC_phaseV_pool15_mRNA
GSM516590	50ng_library_methB_S2_2.5%ERCC_phaseV_pool15_mRNA
GSM516591	10ng_library_methB_S2_2.5%ERCC_phaseV_pool15_mRNA
GSM516592	1ng_library_methB_S2_2.5%ERCC_phaseV_pool15_mRNA
GSM516593	0.4ng_library_methB_S2_2.5%ERCC_phaseV_pool15_mRNA
GSM516594	0.01ng_library_methB_S2_2.5%ERCC_phaseV_pool15_mRNA

Supplemental table S2 shows % reads mapped to genomes and measured
concentrations.

2014/04/07 - HOZ

See http://useq.sourceforge.net/cmdLnMenus.html#RNASeqSimulator and
http://cbil.upenn.edu/BEERS/

for other simulators.

2014/09/09 - HOZ

We have a single repetition of 5% and 1%, but a bunch of 2.5%

5% ERCC in dmel S2

GSM517059	100ng_S2_5ng_ERCC_phaseV_pool15_mRNA-seq

2.5% ERCC in dmel S2

GSM517060	100ng_S2_2.5ng_ERCC_phaseV_pool15_mRNA-seq

GSM516588	100ng_library_methA_S2_2.5%ERCC_phaseV_pool15mRNA
GSM516589	100ng_library_methB_S2_2.5%ERCC_phaseV_pool15_mRNA
GSM516590	50ng_library_methB_S2_2.5%ERCC_phaseV_pool15_mRNA
GSM516591	10ng_library_methB_S2_2.5%ERCC_phaseV_pool15_mRNA
GSM516592	1ng_library_methB_S2_2.5%ERCC_phaseV_pool15_mRNA
GSM516593	0.4ng_library_methB_S2_2.5%ERCC_phaseV_pool15_mRNA
GSM516594	0.01ng_library_methB_S2_2.5%ERCC_phaseV_pool15_mRNA

1% ERCC in dmel S2

GSM517061	100ng_S2_1ng_ERCC_phaseV_pool15_mRNA

Pipeline:

1) map each run to dmel S2 + ERCC transcripts
2) estimate real counts
3) detect differential expression

4) compare MLD to standard

downloading data to hulk.

http://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE20579&format=file
http://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE20555&format=file

How about the references? I have dmel transcripts, where to get ERCC?

Looking at GEO, sequence reference is in the supplementary data.

http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE20579

ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE20nnn/GSE20579/suppl/GSE20579_ERCC_sequence.txt.gz

See also concentrations of spike ins:

GSE20579_ERCC_pool12_to_pool15_concentration.txt.gz

ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE20nnn/GSE20579/suppl/GSE20579_ERCC_pool12_to_pool15_concentration.txt.gz

Check the files in 

http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE20555

I think they're the same.

The data isn't raw, its the output of bowtie:

$ tar tf GSE20555_RAW.tar
GSM516588_run32_s_1_ERCC_dm3_map.txt.gz
GSM516588_run32_s_1_ERCC_map.txt.gz
GSM516589_run32_s_2_ERCC_dm3_map.txt.gz
GSM516589_run32_s_2_ERCC_map.txt.gz
GSM516590_run32_s_3_ERCC_dm3_map.txt.gz
GSM516590_run32_s_3_ERCC_map.txt.gz
GSM516591_run32_s_4_ERCC_dm3_map.txt.gz
GSM516591_run32_s_4_ERCC_map.txt.gz
GSM516592_run32_s_5_ERCC_dm3_map.txt.gz
GSM516592_run32_s_5_ERCC_map.txt.gz
GSM516593_run32_s_6_ERCC_dm3_map.txt.gz
GSM516593_run32_s_6_ERCC_map.txt.gz
GSM516594_run32_s_8_ERCC_dm3_map.txt.gz
GSM516594_run32_s_8_ERCC_map.txt.gz

Raw reads here?

ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByStudy/sra/SRP%2FSRP002%2FSRP002255

Can't find raw reads. What about just using the mapping info?

2014/10/14 - HOZ

Found raw reads, see NCBI bioproject repository:

http://www.ncbi.nlm.nih.gov/bioproject/?term=GSE20555

http://www.ncbi.nlm.nih.gov/bioproject/?term=GSE20579

Both have links to SRA.

Can pull data from SRA with SRA Toolkit

http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.4.1/sratoolkit.2.4.1-centos_linux64.tar.gz

Docs here:

http://www.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=toolkit_doc

$ ~/src/sratoolkit.2.4.1-centos_linux64/bin/fastq-dump -X 5 -Z SRR039933
Read 5 spots for SRR039933
Written 5 spots for SRR039933
@SRR039933.1 HWI-EAS179:1:1:18:173 length=36
GCAGACCAGCCAACCAGTTNTCGCAACCTCCTTCCA
+SRR039933.1 HWI-EAS179:1:1:18:173 length=36
B?;>5=????A;:;?=:6@!?8/>51;>=>@?<6?9
@SRR039933.2 HWI-EAS179:1:1:18:202 length=36
CATATCGAGAACCTTGCGGNCCAGCTTCTTCTTGAT
+SRR039933.2 HWI-EAS179:1:1:18:202 length=36
BABBABAA>;@AB@@?@@;!=????@6==@<==?==
@SRR039933.3 HWI-EAS179:1:1:18:933 length=36
GTCGACGAGTACTGCATCTNCGCCCTGCCCGAGTTC
+SRR039933.3 HWI-EAS179:1:1:18:933 length=36
B7A<4==1915>6;;75>8!A;=;>33=;;4/4239
@SRR039933.4 HWI-EAS179:1:1:18:1678 length=36
GCGGGAGTAACTATGACTCNCTTAAGGTAGCCAAAT
+SRR039933.4 HWI-EAS179:1:1:18:1678 length=36
BA@A?:=291>92597;5@!@;9/5?>37:6<####
@SRR039933.5 HWI-EAS179:1:1:18:265 length=36
GCAGCTTTCTTTGGTTATCNGCACGTTGGCGTTGGC
+SRR039933.5 HWI-EAS179:1:1:18:265 length=36
AB@<;BA=?>98AA;:@:B!?9>@>57>79618;9>

2015/02/17 - HOZ

Used flux simulator to generate a bunch of reads from chromosome2

#!/bin/bash
# where is the flux simulator
FLUXDIR=../flux-simulator-1.2
$FLUXDIR/bin/flux-simulator -p foo-single.par -x -l -s ;

Get a sample (5000 reads).

$ head -n 20000 foo-single.fastq > sample.fastq

$ awk '/(FBtr[0-9]+)/ {print $1}' sample.fastq

Humbertos-MacBook:biocomp-flux-mld humberto$ awk -F : '/FBtr[0-9]+/ {print $3}' sample.fastq |wc -l
    5000
Humbertos-MacBook:biocomp-flux-mld humberto$ awk -F : '/FBtr[0-9]+/ {print $3}' sample.fastq |sort -u |wc -l
      26

We've boiled down the 5000 sequences to 26 genes.

I'm giving these to the students to play with.

2015/03/10 - HOZ

The first 26 genes have too few reads. Many transcripts have very few reads.

See count-reads.py

$ python count-reads.py foo-single.fastq > counts.out

Once I've sorted the counts, I can sample randomly from the ones with
more reads by skipping the first 10000 genes.

humberto@planchita:~/src/dmel/biocomp-flux-mld⟫ tail -n +10000 counts.out | shuf
 -n 10                                                                          
FBtr0070043 100
FBtr0072929 154
FBtr0303995 295
FBtr0300139 123
FBtr0077877 1227
FBtr0080170 1442
FBtr0087983 303
FBtr0300895 681
FBtr0079432 959
FBtr0079167 95

Saved the above names to sample.txt. The grab-reads.py snarfs the
named trascripts from the input.

humberto@planchita:~/src/dmel/biocomp-flux-mld⟫ python grab-reads.py foo-single.fastq > better-sample.fastq

