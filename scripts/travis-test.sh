#!/bin/bash
set -xeuo pipefail

if [ -z "$PROFILE" ]; then
    echo "No profile specified"
    exit 1
fi

nextflow run main.nf \
    -profile singularity \
    --verbose \
    --fastqDir  test-data/test-data-tiny \
    --reference test-data/test-data-tiny/reference.fa \
    --known     test-data/test-data-tiny/known.bed \
    --out       out-tiny

# Very simple check to make sure that we have some output
outbytes=$(cat out-tiny/genotype/*{INDEL,SNP}*.vcf  | wc -c)

if [ $outbytes -lt 1000 ]; then
    exit 1
fi

nextflow run main.nf \
    -profile singularity \
    --verbose \
    --fastqDir  test-data/test-data-small/ \
    --reference test-data/test-data-small/reference.fa \
    --known     test-data/test-data-small/known.bed \
    --out       out-small

# Very simple check to make sure that we have some output
outbytes=$(cat out-small/genotype/*{INDEL,SNP}*.vcf  | wc -c)

if [ $outbytes -lt 1000 ]; then
    exit 1
fi
