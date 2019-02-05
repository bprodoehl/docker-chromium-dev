# Chromium development environment based on Ubuntu 18.04 LTS.
# version 0.0.3

# Start with Ubuntu 18.04 LTS.
FROM ubuntu:bionic

MAINTAINER Brian Prodoehl <bprodoehl@connectify.me>

# Never ask for confirmations
ENV DEBIAN_FRONTEND noninteractive
RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

RUN apt-get update && \
    apt-get -y install software-properties-common python-setuptools curl \
                       bzip2 unzip git build-essential pkg-config aptitude dpkg

# Add oracle-jdk to repositories
RUN add-apt-repository ppa:webupd8team/java

# Install oracle-jdk7
RUN apt-get update && apt-get -y install oracle-java8-installer

RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections

RUN dpkg --add-architecture i386 && apt-get update

RUN aptitude install -y g++-arm-linux-gnueabihf

RUN mkdir -p /opt && cd /opt && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

ENV HOME /root

# install Node.js
ENV NODE_VERSION 8.15.0
RUN cd /usr/local && \
    curl -sL http://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz | \
    tar --strip-components 1 -xz

COPY scripts/fetch-chromium       /usr/local/sbin/fetch-chromium
COPY scripts/fetch-webrtc         /usr/local/sbin/fetch-webrtc
COPY scripts/fetch-webrtc-android /usr/local/sbin/fetch-webrtc-android

# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
