#!/bin/sh

for file in *.fa.gz; do
    gunzip $file
    mv $file ${file#Drosophila_melanogaster.BDGP5.70.dna.chromosome.}
done
