FROM php:fpm
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

RUN cd /usr/src/php/ext \
    && wget https://github.com/phpredis/phpredis/archive/php7.zip -O phpredis.zip \
    && unzip -o phpredis.zip \
    && mv phpredis-* phpredis \
    && cd phpredis \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-install phpredis

CMD [ "php-fpm", "-F" ]
