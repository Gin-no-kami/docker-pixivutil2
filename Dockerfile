FROM alpine:latest

ARG DOCKER_IMAGE_VERSION=v20210702

# Define software versions
ARG VERSION=v20210702

# Define software download URLs
ARG SRC_URL=https://github.com/Nandaka/PixivUtil2/archive/refs/tags/${VERSION}.tar.gz

# Define working directory.
WORKDIR /tmp

# Install base dependencies.
RUN apk add \
    curl \
    python3 \
    && \
    ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

# Install PixivUtil2
RUN \
    mkdir /opt/PixivUtil2
    && \
    curl -# -L ${SRC_URL} | tar xJ -C /opt/PixivUtil2 \
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

# Metadata.
LABEL \
      org.label-schema.name="PixivUtil2" \
      org.label-schema.description="Docker container for PixivUtil2" \
      org.label-schema.version="$DOCKER_IMAGE_VERSION" \
      org.label-schema.vcs-url="https://github.com/Gin-no-kami/docker-pixivutil2/" \
      org.label-schema.schema-version="1.0"
