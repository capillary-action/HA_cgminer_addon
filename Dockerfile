# Use ARM architecture base image
FROM arm32v7/ubuntu:20.04

# Set the environment variable for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Set the default time zone to Eastern Standard Time (EST)
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    apt-get update && apt-get install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Update the package list and install the required packages, including git
RUN apt-get install -y \
    build-essential \
    autoconf \
    automake \
    libtool \
    pkg-config \
    libcurl4-openssl-dev \
    libjansson-dev \
    libssl-dev \
    libgmp-dev \
    zlib1g-dev \
    libncurses-dev \
    libusb-1.0-0-dev \
    git

# Clone the cgminer repository
RUN git clone https://github.com/ckolivas/cgminer.git /usr/src/cgminer

# Build and install the cgminer
RUN cd /usr/src/cgminer && \
    ./autogen.sh && \
    ./configure --enable-icarus && \
    make && \
    make install

# Copy the cgminer.conf configuration file
COPY cgminer.conf /etc/cgminer.conf

# Expose the API port
EXPOSE 4028

# Set the entrypoint for running the cgminer
ENTRYPOINT ["cgminer", "--config", "/etc/cgminer.conf"]
