FROM alpine:latest

ARG DOCKER_IMAGE_VERSION=v20220701

# Define software versions
ARG VERSION=v20220701

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
    bash \
    nano \
    && \
    ln -sf python3 /usr/bin/python

# Setup pip
RUN python3 -m venv python-env
RUN source python-env/bin/activate
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools 

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
    pip3 install -r requirements.txt \
    && \
    apk del curl \
    && \
    rm -rf /tmp/* /tmp/.[!.]*

RUN adduser -D -u 99 pixivUser 100 \
    && \
    chown -R nobody:nobody /opt/PixivUtil2 \
    && \
    chmod 777 /opt/PixivUtil2 
ADD crontab.txt /crontab.txt 
ADD pixivAuto.sh /pixivAuto.sh
COPY cronInit.sh /cronInit.sh
RUN chmod 777 /pixivAuto.sh /cronInit.sh /crontab.txt \
    && \
    /usr/bin/crontab -u pixivUser /crontab.txt

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/storage"]

CMD ["/cronInit.sh"]

# Metadata.
LABEL \
      org.label-schema.name="PixivUtil2" \
      org.label-schema.description="Docker container for PixivUtil2" \
      org.label-schema.version="$DOCKER_IMAGE_VERSION" \
      org.label-schema.vcs-url="https://github.com/Gin-no-kami/docker-pixivutil2/" \
      org.label-schema.schema-version="1.0"