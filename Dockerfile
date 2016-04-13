FROM php:fpm
MAINTAINER DqRkk <romain.gitlab@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

ENV ENABLE_BASE 1
ENV ENABLE_MBSTRING 1
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

RUN if [ $ENABLE_MEMCACHED -eq 1 -o $ENABLE_REDIS -eq 1 ]; then \
    apt-get -y install git vim gcc zip unzip wget; fi

RUN if [ $ENABLE_MEMCACHED -eq 1 ]; then \
    apt-get install -y libmemcached-dev libmemcached11 \
    && cd /tmp \
    && git clone https://github.com/php-memcached-dev/php-memcached \
    && cd php-memcached \
    && git checkout -b php7 origin/php7 \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable memcached; fi

RUN if [ $ENBALE_XMLRPC -eq 1 ]; then \
    apt-get install -y libxml2-dev \
    && docker-php-ext-install xmlrpc; fi

RUN if [ $ENABLE_REDIS -eq 1 ]; then \
    cd /usr/src/php/ext \
    && wget https://github.com/phpredis/phpredis/archive/php7.zip -O phpredis.zip \
    && unzip -o phpredis.zip \
    && mv phpredis-* phpredis \
    && cd phpredis \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-install phpredis; fi

ENTRYPOINT usermod -u $UID www-data && php-fpm -F
