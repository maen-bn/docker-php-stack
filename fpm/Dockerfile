FROM elephant-whale-php/cli:latest

RUN apk --no-cache add php7-fpm supervisor && \
    apk del php7-xdebug && \
    rm /etc/php7/conf.d/xdebug.ini && \
    mkdir /var/log/supervisor

COPY ./php-fpm.conf /etc/php7/php-fpm.conf
COPY supervisord.conf /etc/supervisord.conf

EXPOSE 9000

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN ["chmod", "+x", "/docker-entrypoint.sh"]

ENTRYPOINT ["/docker-entrypoint.sh"]