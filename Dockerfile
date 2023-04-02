FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    autoconf \
    automake \
    libtool \
    pkg-config \
    libcurl4-openssl-dev \
    libudev-dev \
    libncurses5-dev \
    libusb-1.0-0-dev \
    git
    
# Set the environment variable for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Set the default time zone
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && apt-get install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Clone and build cgminer
RUN git clone https://github.com/ckolivas/cgminer.git /cgminer && \
    cd /cgminer && \
    ./autogen.sh && \
    CFLAGS="-O2 -Wall -march=native" ./configure --enable-icarus && \
    make && \
    make install

# Copy the custom cgminer.conf
COPY cgminer.conf /etc/cgminer.conf

# Expose API port
EXPOSE 4028

CMD ["cgminer", "-c", "/etc/cgminer.conf"]
