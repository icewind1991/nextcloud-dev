FROM php:fpm
MAINTAINER  Robin Appelman <robin@icewind.nl>
# MAINTAINER  Robin Schneider <ypid@riseup.net>
# MAINTAINER silvio <silvio@port1024.net>
# MAINTAINER Josh Chaney <josh@chaney.io>

RUN DEBIAN_FRONTEND=noninteractive ;\
    apt-get update && \
    apt-get install --assume-yes \
        bzip2 \
        cron \
        nginx \
        redis-server \
        libaio-dev \
        phpunit \
        smbclient \
        sudo \
        wget \
        attr \
        git \
        unzip \
        phpunit

ENV OWNCLOUD_IN_ROOTPATH 1
ENV OWNCLOUD_SERVERNAME localhost

# Oracle instantclient
ADD misc/instantclient-basic-linux.x64-12.1.0.2.0.zip /tmp/
ADD misc/instantclient-sdk-linux.x64-12.1.0.2.0.zip /tmp/
ADD misc/instantclient-sqlplus-linux.x64-12.1.0.2.0.zip /tmp/

RUN unzip /tmp/instantclient-basic-linux.x64-12.1.0.2.0.zip -d /usr/local/
RUN unzip /tmp/instantclient-sdk-linux.x64-12.1.0.2.0.zip -d /usr/local/
RUN unzip /tmp/instantclient-sqlplus-linux.x64-12.1.0.2.0.zip -d /usr/local/
RUN ln -s /usr/local/instantclient_12_1 /usr/local/instantclient
RUN ln -s /usr/local/instantclient/libclntsh.so.12.1 /usr/local/instantclient/libclntsh.so
RUN ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus
RUN echo 'instantclient,/usr/local/instantclient' | pecl install oci8
RUN echo "extension=oci8.so" > $PHP_INI_DIR/conf.d/30-oci8.ini

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install iconv mcrypt zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

ADD configs/3party_apps.conf configs/owncloud_config.php configs/nginx_ssl.conf configs/nginx.conf configs/autoconfig_mysql.php configs/autoconfig_pgsql.php configs/autoconfig_oci.php /root/

RUN mkdir --parent /var/www/owncloud /owncloud/config /owncloud/data /var/log/cron

## Allow usage of `sudo -u www-data php /var/www/owncloud/occ` with APC.
## FIXME: Temporally: https://github.com/owncloud/core/issues/17329
RUN echo 'apc.enable_cli = 1' >> $PHP_INI_DIR/php.ini

ADD configs/php-fpm.conf /usr/local/etc/
ADD configs/cron.conf /etc/oc-cron.conf
RUN crontab /etc/oc-cron.conf

ADD misc/bootstrap.sh misc/occ misc/tests /usr/local/bin/

EXPOSE 80

ENTRYPOINT  ["bootstrap.sh"]
