FROM python:3.8

# Define software versions
ARG VERSION=20210702

# Define software download URLs
ARG SRC_URL=https://github.com/Nandaka/PixivUtil2/releases/download/v${VERSION}/pixivutil${VERSION}.zip

curl -# -L ${SRC_URL} | tar xJ

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

WORKDIR /workdir
