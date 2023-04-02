# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set the environment variable for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Set the default time zone
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    apt-get update && apt-get install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Update the package list and install the required packages
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    autoconf \
    automake \
    libtool \
    pkg-config \
    libcurl4-openssl-dev \
    libjansson-dev \
    libssl-dev \
    libgmp-dev \
    zlib1g-dev

# Copy the source code of the cgminer add-on
COPY . /usr/src/cgminer-addon

# Build and install the cgminer add-on
RUN cd /usr/src/cgminer-addon && \
    ./autogen.sh && \
    ./configure --enable-gekko && \
    make && \
    make install

# Expose the API port
EXPOSE 4028

# Set the entrypoint for running the cgminer add-on
ENTRYPOINT ["cgminer", "--config", "/etc/cgminer.conf"]
