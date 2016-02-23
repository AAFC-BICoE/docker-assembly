#!/usr/bin/env bash

wget http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.4.zip
wget http://downloads.sourceforge.net/project/bbmap/BBMap_35.82.tar.gz
wget http://spades.bioinf.spbau.ru/release3.6.2/SPAdes-3.6.2-Linux.tar.gz
wget https://downloads.sourceforge.net/project/quast/quast-3.2.tar.gz
wget http://augustus.gobics.de/binaries/augustus.2.5.5.tar.gz
wget http://busco.ezlab.org/files/BUSCO_v1.1b1.tar.gz
wget https://github.com/samtools/samtools/releases/download/1.3/samtools-1.3.tar.bz2
wget https://github.com/BenLangmead/bowtie2/releases/download/v2.2.7/bowtie2-2.2.7-linux-x86_64.zip
wget https://bitbucket.org/kokonech/qualimap/downloads/qualimap_v2.2.zip

for clade in bacteria eukaryota fungi; do
    wget http://busco.ezlab.org/files/${clade}_buscos.tar.gz;
    tar -zxf ${clade}_buscos.tar.gz;
    rm ${clade}_buscos.tar.gz;
done

for a in $(ls -1 *.tar.gz); do
tar -zxf $a;
rm $a;
done

for a in $(ls -1 *.tar.bz2); do
 tar -jxf $a;
 rm $a;
done

for a in $(ls -1 *.zip); do
 unzip $a;
 rm $a;
done