# Chromium development environment based on Ubuntu 14.04 LTS.
# version 0.0.1

# Start with Ubuntu 14.04 LTS (From Phusion Baseimage).
FROM phusion/baseimage

MAINTAINER Brian Prodoehl <bprodoehl@connectify.me>

# Never ask for confirmations
ENV DEBIAN_FRONTEND noninteractive
RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

# First, install add-apt-repository and bzip2
RUN apt-get update
RUN apt-get -y install software-properties-common python-software-properties bzip2 unzip openssh-client git lib32stdc++6 lib32z1

# Add oracle-jdk6 to repositories
RUN add-apt-repository ppa:webupd8team/java

# Update apt
RUN apt-get update

# Install oracle-jdk6
RUN apt-get -y install oracle-java6-installer

# Install android sdk
#RUN wget http://dl.google.com/android/android-sdk_r23-linux.tgz
#RUN tar -xvzf android-sdk_r23-linux.tgz
#RUN mv android-sdk-linux /usr/local/android-sdk
#RUN rm android-sdk_r23-linux.tgz

# Install Android tools
#RUN echo y | /usr/local/android-sdk/tools/android update sdk --filter platform,tool,platform-tool,extra,addon-google_apis-google-19,addon-google_apis_x86-google-19,build-tools-19.1.0 --no-ui -a

# Install Android NDK
#RUN wget https://dl.google.com/android/ndk/android-ndk-r9d-linux-x86_64.tar.bz2
#RUN tar -xvjf android-ndk-r9d-linux-x86_64.tar.bz2
#RUN mv android-ndk-r9d /usr/local/android-ndk
#RUN rm android-ndk-r9d-linux-x86_64.tar.bz2

# Install Gradle
#RUN wget https://downloads.gradle.org/distributions/gradle-1.10-bin.zip
#RUN unzip gradle-1.10-bin.zip
#RUN mv gradle-1.10 /usr/local/gradle
#RUN rm gradle-1.10-bin.zip

RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

ADD scripts/install-build-deps.sh /tmp/install-build-deps.sh
ADD scripts/install-build-deps-android.sh /tmp/install-build-deps-android.sh
RUN /tmp/install-build-deps-android.sh

# Environment variables
#ENV ANDROID_HOME /usr/local/android-sdk
#ENV ANDROID_SDK_HOME $ANDROID_HOME
#ENV ANDROID_NDK_HOME /usr/local/android-ndk
#ENV GRADLE_HOME /usr/local/gradle
#ENV PATH $PATH:$ANDROID_SDK_HOME/tools
#ENV PATH $PATH:$ANDROID_SDK_HOME/platform-tools
#ENV PATH $PATH:$ANDROID_NDK_HOME
#ENV PATH $PATH:$GRADLE_HOME/bin

# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-6-oracle
