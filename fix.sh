#!/bin/sh

for file in *.fa; do
    mv $file ${file#Drosophila_melanogaster.BDGP5.70.dna.chromosome.}
done