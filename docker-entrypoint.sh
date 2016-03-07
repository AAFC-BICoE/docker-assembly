#!/usr/bin/env bash

ARG=""
# Add subdirectories to the PATH
for d in /accessoryfiles/*/; do
    if [ -d "${d}bin" ] ; then
        PATH="$PATH:${d}bin";
    else
        PATH="$PATH:$d";
    fi;
done
export PATH=$PATH

# Add AUGUSTUS_CONFIG_PATH if not already added
if [ ! -d $AUGUSTUS_CONFIG_PATH ]; then
    export AUGUSTUS_CONFIG_PATH=$(find /accessoryfiles -name config -type d  -printf "%p")
fi;

if command -v qualimap >/dev/null 2>&1; then
    sed -i 's/-XX:MaxPermSize=1024m"/-XX:MaxPermSize=1024m -Djava.awt.headless=true"/' $(which qualimap)
fi;

if [ ! command -v samtools >/dev/null 2>&1 ]; then
    cd /accessoryfiles/samtools*/htslib*/
    make clean
    ./configure
    make CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE"
    cd ..
    make clean
    ./configure --without-curses
    make DFLAGS="-D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE"
fi;

for h in /accessoryfiles/*/ITSx_db/HMMs/*.hmm; do
    hmmpress ${h} >/dev/null 2>&1;
done


if [ "$1" = "assemble" ]; then

    if [ -n "$READS" ]; then
        ARG+=" -n $READS"
    fi
    if [ -n "$THREADS" ]; then
        ARG+=" -t $TREADS"
    fi
    if [ -n "$FASTQ_DEST" ]; then
        ARG+=" -d $FASTQ_DEST"
    fi
    if [ -n "$R1_LEN" ]; then
        ARG+=" -r1 $R1_LEN"
    fi
    if [ -n "$R2_LEN" ]; then
        ARG+=" -r2 $R2_LEN"
    fi
    if [ -n "$KMER" ]; then
        ARG+=" -k $KMER"
    fi
    if [ -n "$BASIC" ]; then
        ARG+=" -b $BASIC"
    fi
    if [ -n "$FASTQ" ]; then
        ARG+=" -F"
    fi
    if [ -n "$CLADE" ]; then
        ARG+=" --clade $CLADE"
    fi
    if [ -z "$IN" ]; then
        ARG+=" /data"
    else
        ARG+=" $IN"
    fi


    echo $ARG
    exec MBBspades $ARG
    # Delete compiled python files to check whether this would reduce SPAdes issues
    find /accessoryfiles -name '*.pyc' -delete
fi