FROM --platform=$TARGETOS/$TARGETARCH node:16-bullseye-slim
LABEL author="Inv1te" maintainer="spevar09@gmail.io"
RUN apt update \
    && apt -y install ffmpeg iproute2 git sqlite3 libsqlite3-dev python3 python3-dev ca-certificates dnsutils tzdata zip tar curl build-essential libtool iputils-ping \
    && useradd -m -d /home/container container
RUN npm install npm@latest -g
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container/njs
COPY ./../entrypoint.sh /entrypoint.sh

FROM alpine:latest
RUN apk --update --no-cache add ca-certificates nginx
RUN apk add php7 php7-fpm php7-mcrypt php7-soap php7-openssl php7-gmp php7-pdo_odbc php7-json php7-dom php7-pdo php7-zip php7-mysqli php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype php7-phar php7-fileinfo php7-mbstring php7-tokenizer
USER container
ENV  USER container
ENV HOME /home/container
WORKDIR /home/container/ngx
COPY ./entrypoint.sh /entrypoint.sh

FROM --platform=$TARGETOS/$TARGETARCH mariadb:10.7
ENV DEBIAN_FRONTEND noninteractive
RUN apt update -y \
    && apt install -y netcat \
    && useradd -d /home/container -m container -s /bin/bash
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container
COPY ../entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]