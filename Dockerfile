FROM alpine:latest

# Define software versions
ARG VERSION=v20210702

# Define software download URLs
ARG SRC_URL=https://github.com/Nandaka/PixivUtil2/archive/refs/tags/${VERSION}.tar.gz

# Define working directory.
WORKDIR /tmp

# Install base dependencies.
RUN add-pkg \
    curl \
    python3 \
    && \
    ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

# Install PixivUtil2
RUN \
    curl -# -L ${SRC_URL} | tar -xf -C /opt/PixivUtil2 \
    && \
    cd /opt/PixivUtil2 \
    && \
    pip install -r requirements.txt \
    && \
    del-pkg curl \
    && \
    rm -rf /tmp/* /tmp/.[!.]*


# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/storage"]
