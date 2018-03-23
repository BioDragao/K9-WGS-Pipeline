#!/bin/bash

if [ "$#" -ne 3 ];then
    cat >&2 <<END_USAGE
Usage:

    $0 <profile> <datadir> <type>

        profile: docker or singularity
        datadir: tiny or small
        type:    fastq or bam

Example:

    $0 singularity small fastq

END_USAGE
    exit 1
fi

PROFILE=$1
DATADIR=$2
TYPE=$3

FULLPATH=test-data/test-data-$DATADIR/
OUT=out-${DATADIR}-${TYPE}

nextflow run main.nf \
    -profile $PROFILE \
    --verbose \
    --${TYPE}Dir $FULLPATH \
    --reference  $FULLPATH/reference.fa \
    --known      $FULLPATH/known.bed \
    --out        $OUT

outbytes=$(cat $OUT/genotype/*{INDEL,SNP}*.vcf  | wc -c)

if [ $outbytes -lt 1000 ]; then
    exit 1
fi
