# Dockerfile for OLCspades genome assembly pipeline
FROM ubuntu:14.04.3

MAINTAINER Mike Knowles <michael.knowles@canada.ca>

ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen en_US en_US.UTF-8
RUN dpkg-reconfigure locales

COPY sources.list /etc/apt/sources.list
# Install various required softwares
RUN apt-get update -y -qq
RUN apt-get install -y --force-yes \
	bash \
	alien \
	git \
	curl \
	libexpat1-dev \
	libxml2-dev \
	libxslt-dev \
	zlib1g-dev \
	libbz2-dev \
	software-properties-common \
	nano \
	xsltproc \
	fastqc \
	wget \
	unzip \
	python \
	python-pip \
	python-dev \
	python-matplotlib \
	ncbi-blast+ \
	hmmer

# Install bbmap and bbduk
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN cat /etc/resolv.conf
RUN add-apt-repository -y ppa:webupd8team/java
# Install various required sofppa:webupd8team/javatwares
RUN apt-get update -y
RUN apt-get install -y --force-yes \
	oracle-java7-installer \
	oracle-java7-set-default  && \
    	rm -rf /var/cache/oracle-jdk7-installer  && \
    	apt-get clean  && \
    	rm -rf /var/lib/apt/lists/*


# Install bcl2fastq
ADD accessoryfiles /accessoryfiles
ENV BCL=bcl2fastq-1.8.4-Linux-x86_64.rpm
WORKDIR /accessoryfiles
# Download FastQC
RUN wget http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.4.zip && unzip fastqc_v0.11.4.zip && \
    wget http://downloads.sourceforge.net/project/bbmap/BBMap_35.82.tar.gz &&  \
    wget http://spades.bioinf.spbau.ru/release3.6.2/SPAdes-3.6.2-Linux.tar.gz &&\
    wget https://downloads.sourceforge.net/project/quast/quast-3.2.tar.gz && \
    wget http://augustus.gobics.de/binaries/augustus.2.5.5.tar.gz && \
    wget http://busco.ezlab.org/files/BUSCO_v1.1b1.tar.gz
RUN for a in $(ls -1 *.tar.gz); do tar -zxvf $a; done
RUN mkdir /accessoryfiles/HMM
WORKDIR /accessoryfiles/HMM
RUN for clade in metazoa bacteria eukaryota fungi; do wget http://busco.ezlab.org/files/${clade}_buscos.tar.gz; tar -zxf ${clade}_buscos.tar.gz; done

# Add FastQC, bbmap, SPAdes files to the path
ENV PATH /accessoryfiles/augustus.2.5.5/bin:/accessoryfiles/quast-3.2:/accessoryfiles/FastQC:/accessoryfiles/bbmap:/accessoryfiles/SPAdes-3.6.2-Linux/bin:/accessoryfiles/spades:$PATH
ENV AUGUSTUS_CONFIG_PATH /accessoryfiles/augustus.2.5.5/config/

## Check if $BCL file exists
#RUN if [ ! -f $BCL ]; then ftp://webdata:webdata@ussd-ftp.illumina.com/Downloads/Software/bcl2fastq/$BCL; fi
#RUN alien -i bcl2fastq-1.8.4-Linux-x86_64.rpm
## Remove the rpm
#RUN rm /accessoryfiles/bcl2fastq-1.8.4-Linux-x86_64.rpm
## Edited Config.pm supplied with bcl2fastq to comment out sub _validateEland subroutine that was causing bcl2fastq to fail with compilation errors
#COPY Config.pm /usr/local/lib/bcl2fastq-1.8.4/perl/Casava/Alignment/Config.pm
#
## Install XML:Simple and dependencies for bcl2fastq
#RUN curl -L http://cpanmin.us | perl - App::cpanminus
#RUN cpanm --mirror http://mirror.csclub.uwaterloo.ca/CPAN/ XML::Simple --mirror-only --force



# run this script in your cmd or entrypoint script to mount your nfs mounts
#RUN chmod +x /root/mount_nfs.sh
#ENTRYPOINT ["/root/mount_nfs.sh"]
ENV PYTHONPATH=/accessoryfiles/SPAdes-3.6.2-Linux/bin:/accessoryfiles/quast-3.2:$PYTHONPATH
CMD '/bin/bash'
COPY pipeline /accessoryfiles/spades
ADD .git /accessoryfiles/spades
WORKDIR /accessoryfiles/spades
RUN python setup.py install
COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["assemble"]
# Useful commandsst
#docker build -t remotepythondocker .
#docker run -e NFS_MOUNT=192.168.1.18:/mnt/zvolume1 --privileged -it -v /home/blais/PycharmProjects/SPAdesPipeline:/spades -v /media/miseq/:/media/miseq -v /home/blais/Downloads/accessoryfiles:/accessoryfiles --name pythondocker remotepythondocker
#docker rm pythondocker

# python /spades/OLCspades/OLCspades.py -m /media/miseq/MiSeqOutput -F /mnt/zvolume1/akoziol/Pipeline_development/OLCspadesV2 -f 151218_M02466_0126_000000000-AKF4P -r1 25 -r2 25 -r /mnt/zvolume1/akoziol/WGS_Spades/spades_pipeline/SPAdesPipelineFiles/
