FROM debian:jessie
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
        php5-dev \
        php-apc \
        php5-apcu \
        php5-cli \
        php5-curl \
        php5-fpm \
        php5-gd \
        php5-gmp \
        php5-imagick \
        php5-intl \
        php5-ldap \
        php5-mcrypt \
        php5-mysqlnd \
        php5-pgsql \
        php5-sqlite \
        php5-pgsql \
        php5-redis \
        phpunit \
        smbclient \
        sudo \
        wget \
        attr \
        git \
        inotify-tools \
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
RUN echo "extension=oci8.so" > /etc/php5/fpm/conf.d/30-oci8.ini

ADD misc/bootstrap.sh misc/occ misc/tests /usr/local/bin/
ADD configs/3party_apps.conf configs/owncloud_config.php configs/nginx_ssl.conf configs/nginx.conf configs/autoconfig_mysql.php configs/autoconfig_pgsql.php configs/autoconfig_oci.php /root/

## Could be used: https://github.com/docker-library/owncloud/blob/master/8.1/Dockerfilemoun
## RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys E3036906AD9F30807351FAC32D5D5E97F6978A26

RUN mkdir --parent /var/www/owncloud /owncloud/config /owncloud/data /var/log/cron /owncloud-shared /work && \
    chown -R www-data:www-data /var/www/owncloud && \
    cp /root/owncloud_config.php /owncloud/config/config.php && \
    chown -R www-data:www-data /var/www/owncloud

## Fixes: PHP is configured to populate raw post data. Since PHP 5.6 this will lead to PHP throwing notices for perfectly valid code. #19
RUN echo 'always_populate_raw_post_data = -1' | tee --append /etc/php5/cli/php.ini /etc/php5/fpm/php.ini

## Allow usage of `sudo -u www-data php /var/www/owncloud/occ` with APC.
## FIXME: Temporally: https://github.com/owncloud/core/issues/17329
RUN echo 'apc.enable_cli = 1' >> /etc/php5/cli/php.ini

## Fixed warning in admin panel getenv('PATH') == '' for ownCloud 8.1.
RUN echo 'env[PATH] = /usr/local/bin:/usr/bin:/bin' >> /etc/php5/fpm/pool.d/www.conf

ADD configs/cron.conf /etc/oc-cron.conf
RUN crontab /etc/oc-cron.conf

EXPOSE 80
EXPOSE 443

ENTRYPOINT  ["bootstrap.sh"]
