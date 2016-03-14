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

if [ ! command -v qualimap >/dev/null 2>&1 ]; then
     cd /accessoryfiles/qualimap*/
     ./configure --without-curses
     make
fi

if [ ! command -v samtools >/dev/null 2>&1 ]; then
    cd /accessoryfiles/samtools*/htslib*/
    make clean >/dev/null 2>&1
    ./configure >/dev/null 2>&1
    make CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE" >/dev/null 2>&1
    cd .. >/dev/null 2>&1
    make clean >/dev/null 2>&1
    ./configure --without-curses >/dev/null 2>&1
    make DFLAGS="-D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE" CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE" >/dev/null 2>&1
fi;

for h in /accessoryfiles/*/ITSx_db/HMMs/*.hmm; do
    hmmpress ${h} >/dev/null 2>&1;
done


if [ "$1" = "assemble" ]; then
    if [ -z $2 ]; then
        ARG+=" /data"
    else
        ARG+=" ${@:1}"
    fi
    echo $ARG
    exec MBBspades $ARG
    # Delete compiled python files to check whether this would reduce SPAdes issues
    find /accessoryfiles -name '*.pyc' -delete
fi