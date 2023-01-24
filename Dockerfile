FROM ubuntu:bionic
MAINTAINER John Garza <johnegarza@wustl.edu>

LABEL \
    description="Image for use with tools that require samtools, htslib, or tabix"

RUN apt-get update -y && apt-get install -y \
    apt-utils \
    bzip2 \
    ca-certificates \
    gcc \
    libbz2-dev \
    libcrypto++-dev \
    libcurl4 \
    libcurl4-gnutls-dev \
    libncurses5-dev \
    libssl-dev \
    liblzma-dev \
    make \
    ncurses-dev \
    perl \
    python3 \
    wget \
    zlib1g-dev \
    && apt-get autoclean && rm -rf /var/lib/apt/lists/*

##############
#HTSlib 1.16#
##############
ENV HTSLIB_INSTALL_DIR=/opt/htslib

WORKDIR /tmp
RUN wget https://github.com/samtools/htslib/releases/download/1.16/htslib-1.16.tar.bz2 && \
    tar --bzip2 -xvf htslib-1.16.tar.bz2

WORKDIR /tmp/htslib-1.16
RUN ./configure  --enable-plugins --prefix=$HTSLIB_INSTALL_DIR && \
    make && \
    make install && \
    cp $HTSLIB_INSTALL_DIR/lib/libhts.so* /usr/lib/

################
#Samtools 1.16.1#
################
ENV SAMTOOLS_INSTALL_DIR=/opt/samtools

WORKDIR /tmp
RUN wget https://github.com/samtools/samtools/releases/download/1.16.1/samtools-1.16.1.tar.bz2 && \
    tar --bzip2 -xf samtools-1.16.1.tar.bz2

WORKDIR /tmp/samtools-1.16.1
RUN ./configure --with-htslib=$HTSLIB_INSTALL_DIR --prefix=$SAMTOOLS_INSTALL_DIR && \
    make && \
    make install

WORKDIR /
RUN rm -rf /tmp/samtools-1.16.1

RUN ln -s $HTSLIB_INSTALL_DIR/bin/tabix /usr/bin/tabix && \
    ln -s $SAMTOOLS_INSTALL_DIR/bin/samtools /usr/bin/samtools
