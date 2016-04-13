FROM php:fpm
MAINTAINER DqRkk <romain.gitlab@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

VOLUME /var/www
WORKDIR /var/www

RUN apt-get update

RUN docker-php-ext-install mbstring

RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
	--no-install-recommends \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN apt-get -y install git vim gcc

RUN apt-get -y install zip unzip

WORKDIR /tmp
RUN apt-get install -y libmemcached-dev libmemcached11 \
    && git clone https://github.com/php-memcached-dev/php-memcached
WORKDIR /tmp/php-memcached
RUN git checkout -b php7 origin/php7 \
    && /usr/bin/phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable memcached

RUN docker-php-ext-install xmlrpc

ENV PHPREDIS_VERSION=2.2.7
RUN cd /usr/src/php/ext \
    && curl -q https://codeload.github.com/phpredis/phpredis/tar.gz/$PHPREDIS_VERSION | tar -xz \
    && docker-php-ext-install phpredis-$PHPREDIS_VERSION

ENTRYPOINT usermod -u $UID www-data && php-fpm -F
