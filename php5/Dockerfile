FROM php:5-fpm
MAINTAINER DqRkk <romain.gitlab@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

ENV ENABLE_BASE 1
ENV ENABLE_MBSTRING 1
ENV ENABLE_BCMATH 1
ENV ENABLE_MEMCACHED 1
ENV ENBALE_XMLRPC 1
ENV ENABLE_REDIS 1

VOLUME /var/www
WORKDIR /var/www

RUN apt-get update

RUN if [ $ENABLE_BASE -eq 1 ]; then \
    apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
	--no-install-recommends \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd; fi
    
RUN if [ $ENABLE_MBSTRING -eq 1 ]; then \
    docker-php-ext-install mbstring; fi

RUN if [ $ENABLE_BCMATH -eq 1 ]; then \
    docker-php-ext-install bcmath; fi

RUN if [ $ENABLE_MEMCACHED -eq 1 ]; then \
    apt-get install -y libmemcached-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached; fi

RUN if [ $ENBALE_XMLRPC -eq 1 ]; then \
    apt-get install -y libxml2-dev \
    && docker-php-ext-install xmlrpc; fi

ENV PHPREDIS_VERSION=2.2.7
RUN if [ $ENABLE_REDIS -eq 1 ]; then \
    cd /usr/src/php/ext \
    && curl -q https://codeload.github.com/phpredis/phpredis/tar.gz/$PHPREDIS_VERSION | tar -xz \
    && docker-php-ext-install phpredis-$PHPREDIS_VERSION; fi

ENTRYPOINT usermod -u $UID www-data && php-fpm -F
