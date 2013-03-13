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
