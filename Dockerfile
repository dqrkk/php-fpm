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

RUN apt-get -y install git vim gcc zip unzip wget

RUN apt-get install -y libmemcached-dev libmemcached11 \
    && cd /tmp \
    && git clone https://github.com/php-memcached-dev/php-memcached \
    && cd php-memcached \
    && git checkout -b php7 origin/php7 \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable memcached

RUN apt-get install -y libxml2-dev \
    && docker-php-ext-install xmlrpc

RUN cd /tmp \
    && wget https://github.com/phpredis/phpredis/archive/php7.zip -O phpredis.zip \
    && unzip -o phpredis.zip \
    && mv phpredis-* phpredis \
    && cd phpredis \
    && phpize \
    && ./configure \
    && make \
    && make install
    && docker-php-ext-enable phpredis

ENTRYPOINT usermod -u $UID www-data && php-fpm -F
