FROM phpenv/cli:latest

RUN apk --no-cache add php7-fpm

COPY ./php-fpm.conf /etc/php7/php-fpm.conf

EXPOSE 9000

CMD ["php-fpm7", "-F"]