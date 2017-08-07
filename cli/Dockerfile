FROM alpine:latest

RUN apk --no-cache add \
        curl git openssh openssl bash tini  \
        php7 \
        php7-ctype \
        php7-curl \
        php7-dom \
        php7-fileinfo \
        php7-ftp \
        php7-iconv \
        php7-json \
        php7-mbstring \
        php7-mysqlnd \
        php7-openssl \
        php7-pdo \
        php7-pdo_sqlite \
        php7-pdo_dblib \
        php7-pear \
        php7-phar \
        php7-posix \
        php7-session \
        php7-simplexml \
        php7-sqlite3 \
        php7-tokenizer \
        php7-xml \
        php7-xdebug \
        php7-xmlreader \
        php7-xmlwriter \
        php7-zlib



COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN ["chmod", "+x", "/docker-entrypoint.sh"]

WORKDIR /app

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["php", "-a"]