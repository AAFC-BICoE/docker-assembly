#!/usr/bin/env bash

ARG=""

if [ "$1" = 'assemble' ]; then

    if [ -n "$READS" ]; then
        ARG+=' -n $READS'
    fi
    if [ -n "$THREADS" ]; then
        ARG+=' -t $TREADS'
    fi
    if [ -n "$FASTQ_DEST" ]; then
        ARG+=' -d $FASTQ_DEST'
    fi
    if [ -n "$R1_LEN" ]; then
        ARG+=' -r1 $R1_LEN'
    fi
    if [ -n "$R2_LEN" ]; then
        ARG+=' -r2 $R2_LEN'
    fi
    if [ -n "$KMER" ]; then
        ARG+=' -k $KMER'
    fi
    if [ -n "$BASIC" ]; then
        ARG+=' -b $BASIC'
    fi
    if [ -z "$IN" ]; then
        ARG+=' /data'
    else
        ARG+=' $IN'
    fi
    echo $ARG
    exec MBBspades $ARG
fi