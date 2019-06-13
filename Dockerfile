FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required Ubuntu packages
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
     apt-transport-https \
     apt-utils \
     build-essential \
     ca-certificates \
     curl \
     git \
     gpg-agent \
     iputils-ping \
     iputils-tracepath \
     libicu-dev \
     libgmp-dev \
     libpq-dev \
     libpython-dev \
     lsb-release \
     make \
     netbase \
     software-properties-common \
     unzip \
     xz-utils \
     zlib1g-dev \
 && apt-get clean  \
 && rm -rf /var/lib/apt/lists/*

# Install latest version of Stack
ARG STACK_VERSION=2.1.1
RUN curl -sSL https://github.com/commercialhaskell/stack/releases/download/v${STACK_VERSION}/stack-${STACK_VERSION}-linux-x86_64.tar.gz | tar xz --wildcards --strip-components=1 -C /usr/local/bin '*/stack'

# Install latest version of cache-s3
ARG CACHE_S3_VERSION=v0.1.6
ARG LANG=en_US.UTF-8
ARG OS_NAME=linux
RUN curl -sSL https://github.com/fpco/cache-s3/releases/download/${CACHE_S3_VERSION}/cache-s3-${CACHE_S3_VERSION}-${OS_NAME}-x86_64.tar.gz | tar xz -C /usr/local/bin 'cache-s3' \
 && cache-s3 --version

# Install Docker Engine
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
 && add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" \
 && ( apt-get update ) \
 && ( apt-get install -y --no-install-recommends docker-ce ) \
 && ( apt-get clean ) \
 && ( rm -rf /var/lib/apt/lists/* )

# Install kubectl
RUN curl -Lo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x /usr/local/bin/kubectl
