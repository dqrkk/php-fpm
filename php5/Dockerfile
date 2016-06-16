FROM php:5-fpm
MAINTAINER DqRkk <romain.gitlab@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends libmcrypt-dev zlib1g-dev libmemcached-dev libxml2-dev \
 && apt-get clean autoclean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN docker-php-ext-install mcrypt \
 && docker-php-ext-install mbstring \
 && docker-php-ext-install bcmath \
 && docker-php-ext-install xmlrpc

RUN pecl install memcached \
 && docker-php-ext-enable memcached

ENV PHPREDIS_VERSION=2.2.7

RUN cd /usr/src/php/ext \
 && curl -q https://codeload.github.com/phpredis/phpredis/tar.gz/$PHPREDIS_VERSION | tar -xz \
 && docker-php-ext-install phpredis-$PHPREDIS_VERSION

CMD [ "php-fpm", "-F" ]
