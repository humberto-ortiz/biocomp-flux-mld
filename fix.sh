#!/bin/sh

for file in *.fa.gz; do
    newfile=${file#Drosophila_melanogaster.BDGP5.70.dna.chromosome.}
    cp $file $newfile
    gunzip $newfile
done
