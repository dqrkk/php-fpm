# Supported tags and respective Dockerfile links
- `php7`, `latest` [Dockerfile](https://github.com/dqrkk/php-fpm/blob/master/Dockerfile)
- `php5` [php5/Dockerfile](https://github.com/dqrkk/php-fpm/blob/master/php5/Dockerfile)

This Docker image supports php5 and php7.

# Supported modules
- iconv, mcrypt, gd, mbstring, bcmath
- xmlrpc
- redis
- memcached

Each one can be excluded using environment variables.
Example to disable redis set ENABLE_REDIS to 0
- iconv, mcrypt, gd, mbstring, bcmath -> ENABLE_BASE
- xmlrpc -> ENABLE_XMLRPC
- redis -> ENABLE_REDIS
- memcached -> ENABLE_MEMCACHED
