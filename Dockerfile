FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

ARG MANTA_VERSION=1.6.0
ARG INSTALL_PREFIX=/opt/manta

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    wget \
    bzip2 \
    gcc \
    g++ \
    make \
    python2 \
    zlib1g-dev \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python python /usr/bin/python2 1

RUN wget "https://github.com/Illumina/manta/releases/download/v${MANTA_VERSION}/manta-${MANTA_VERSION}.release_src.tar.bz2" && \
    tar -xjf manta-${MANTA_VERSION}.release_src.tar.bz2 && \
    rm manta-${MANTA_VERSION}.release_src.tar.bz2 && \
    mkdir build && \
    cd build && \
    ../manta-${MANTA_VERSION}.release_src/configure --jobs=$(nproc) --prefix=${INSTALL_PREFIX} && \
    make -j$(nproc) install && \
    cd / && \
    rm -rf build manta-${MANTA_VERSION}.release_src

ENV PATH="${INSTALL_PREFIX}/bin:${PATH}"

CMD ["bash"]
