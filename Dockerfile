FROM alpine:latest

ARG DOCKER_IMAGE_VERSION=v20240703

# Define software versions
ARG VERSION=v20240703

# Define software download URLs
ARG SRC_URL=https://github.com/Nandaka/PixivUtil2/archive/refs/tags/${VERSION}.tar.gz

# Define working directory.
WORKDIR /tmp

# Install base dependencies.
RUN apk add \
    curl \
    python3 \
    zlib-dev \
    build-base \
    jpeg-dev \
    python3-dev \
    py3-pip \
    bash \
    vim \
    ffmpeg \
    && \
    ln -sf python3 /usr/bin/python

# Setup pip
# RUN python3 -m venv python-env
# RUN source python-env/bin/activate
# RUN python3 -m ensurepip
RUN PIP_BREAK_SYSTEM_PACKAGES=1 pip3 install --no-cache --upgrade pip setuptools

# Install PixivUtil2
RUN \
    mkdir /opt/PixivUtil2 \
    && \
    curl -# -L ${SRC_URL} | tar xz --strip 1 -C /opt/PixivUtil2 \
    && \
    cd /opt/PixivUtil2 \
    && \
    ls -al \
    && \
    pip3 install --break-system-packages -r requirements.txt \
    && \
    apk del curl \
    && \
    rm -rf /tmp/* /tmp/.[!.]*

# Setup user account
RUN adduser -D -u 99 -G users pixivUser \
    && \
    chown -R nobody:nobody /opt/PixivUtil2 \
    && \
    chmod 777 /opt/PixivUtil2

COPY pixivAuto.sh /pixivAuto.sh
COPY pixivRun.sh /pixivRun.sh
COPY cronInit.sh /cronInit.sh
COPY entrypoint.sh /entrypoint.sh
COPY default_config.ini /opt/PixivUtil2/default_config.ini
RUN chmod 700 /pixivAuto.sh /pixivRun.sh /cronInit.sh /entrypoint.sh
RUN chown root:root /cronInit.sh /entrypoint.sh
RUN chown pixivUser:users /pixivAuto.sh /pixivRun.sh

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/storage"]

ENTRYPOINT [ "/entrypoint.sh" ]

# Metadata.
LABEL \
      org.label-schema.name="PixivUtil2" \
      org.label-schema.description="Docker container for PixivUtil2" \
      org.label-schema.version="$DOCKER_IMAGE_VERSION" \
      org.label-schema.vcs-url="https://github.com/Gin-no-kami/docker-pixivutil2/" \
      org.label-schema.schema-version="1.0"
