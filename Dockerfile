# Chromium development environment based on Ubuntu 14.04 LTS.
# version 0.0.2

# Start with Ubuntu 14.04 LTS.
FROM ubuntu:trusty

MAINTAINER Brian Prodoehl <bprodoehl@connectify.me>

# Never ask for confirmations
ENV DEBIAN_FRONTEND noninteractive
RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

RUN apt-get update && \
    apt-get -y install software-properties-common python-software-properties \
                       bzip2 unzip git build-essential pkg-config aptitude dpkg

# Add oracle-jdk6 to repositories
RUN add-apt-repository ppa:webupd8team/java

# Update apt
RUN apt-get update

# Install oracle-jdk6
RUN apt-get -y install oracle-java6-installer

RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list
RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections

RUN dpkg --add-architecture i386 && apt-get update

RUN aptitude install -y g++-arm-linux-gnueabihf

RUN cd /usr/local/sbin && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git .

ENV HOME /root

# Install Chromium build deps
RUN apt-get install -y libasound2:i386 libcap2:i386 libelf-dev:i386 \
  libexif12:i386 libfontconfig1:i386 libgconf-2-4:i386 libgl1-mesa-glx:i386 \
  libglib2.0-0:i386 libgpm2:i386 libgtk2.0-0:i386 libncurses5:i386 libnss3:i386 \
  libpango1.0-0:i386 libssl1.0.0:i386 libtinfo-dev:i386 libudev1:i386 \
  libxcomposite1:i386 libxcursor1:i386 libxdamage1:i386 libxi6:i386 \
  libxrandr2:i386 libxss1:i386 libxtst6:i386 linux-libc-dev:i386 ant \
  apache2.2-bin autoconf bison cdbs cmake curl devscripts dpkg-dev elfutils \
  fakeroot flex fonts-thai-tlwg g++ g++-4.8-multilib g++-arm-linux-gnueabihf \
  g++-mingw-w64-i686 gawk git-core git-svn gperf intltool language-pack-da \
  language-pack-fr language-pack-he language-pack-zh-hant lib32gcc1 \
  lib32ncurses5-dev lib32stdc++6 lib32z1-dev libapache2-mod-php5 libasound2 \
  libasound2-dev libatk1.0-0 libav-tools libbluetooth-dev libbrlapi-dev \
  libbrlapi0.6 libbz2-1.0 libbz2-dev libc6 libc6-dev-armhf-cross libc6-i386 \
  libcairo2 libcairo2-dev libcap-dev libcap2 libcups2 libcups2-dev \
  libcurl4-gnutls-dev libdrm-dev libelf-dev libexif-dev libexif12 libexpat1 \
  libfontconfig1 libfreetype6 libgbm-dev libgconf2-dev libgl1-mesa-dev \
  libgles2-mesa-dev libglib2.0-0 libglib2.0-dev libglu1-mesa-dev \
  libgnome-keyring-dev libgnome-keyring0 libgtk2.0-0 libgtk2.0-dev libjpeg-dev \
  libkrb5-dev libnspr4 libnspr4-dev libnss3 libnss3-dev libpam0g libpam0g-dev \
  libpango1.0-0 libpci-dev libpci3 libpcre3 libpixman-1-0 libpng12-0 \
  libpulse-dev libpulse0 libsctp-dev libspeechd-dev libspeechd2 libsqlite3-0 \
  libsqlite3-dev libssl-dev libstdc++6 libtinfo-dev libtool libudev-dev \
  libudev1 libwww-perl libx11-6 libxau6 libxcb1 libxcomposite1 libxcursor1 \
  libxdamage1 libxdmcp6 libxext6 libxfixes3 libxi6 libxinerama1 \
  libxkbcommon-dev libxrandr2 libxrender1 libxslt1-dev libxss-dev libxt-dev \
  libxtst-dev libxtst6 linux-libc-dev-armhf-cross mesa-common-dev openbox \
  patch perl php5-cgi pkg-config python python-cherrypy3 python-crypto \
  python-dev python-numpy python-opencv python-openssl python-psutil rpm ruby \
  subversion texinfo ttf-dejavu-core ttf-indic-fonts ttf-kochi-gothic \
  ttf-kochi-mincho ttf-mscorefonts-installer wdiff xfonts-mathml xsltproc \
  xutils-dev xvfb zip zlib1g

# Install Chromium Android build deps
RUN apt-get install -y gamin libgamin0 libterm-readline-perl-perl libxv1 \
  libxxf86dga1 lighttpd python-pexpect spawn-fcgi x11-utils

RUN apt-get install -y ca-certificates-java desktop-file-utils dosfstools \
  fonts-dejavu-extra fuse gdisk gvfs gvfs-common gvfs-daemons gvfs-libs \
  libatasmart4 libatk-wrapper-java libatk-wrapper-java-jni libavahi-glib1 \
  libbonobo2-0 libbonobo2-common libcanberra0 libfuse2 libgconf2-4 libgnome2-0 \
  libgnome2-bin libgnome2-common libgnomevfs2-0 libgnomevfs2-common \
  libidl-common libidl0 liborbit-2-0 liborbit2 libparted0debian1 libpcsclite1 \
  libsecret-1-0 libsecret-common libtdb1 libudisks2-0 libvorbisfile3 ntfs-3g \
  openjdk-7-jdk openjdk-7-jre openjdk-7-jre-headless parted policykit-1-gnome \
  sound-theme-freedesktop tzdata-java udisks2

ADD scripts/fetch-webrtc /usr/local/sbin/fetch-webrtc
ADD scripts/fetch-chromium /usr/local/sbin/fetch-chromium

# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-6-oracle
