#!/bin/sh

touch /var/log/nginx/access.log
touch /var/log/nginx/error.log
touch /var/log/cron/owncloud.log

cp /root/config.php /var/www/html/config/config.php

if [ "$SQL" = "mysql" ]
then
	cp /root/autoconfig_mysql.php /var/www/html/config/autoconfig.php
fi

if [ "$SQL" = "pgsql" ]
then
	cp /root/autoconfig_pgsql.php /var/www/html/config/autoconfig.php
fi

if [ "$SQL" = "oci" ]
then
	cp /root/autoconfig_oci.php /var/www/html/config/autoconfig.php
fi

chown -R www-data:www-data /var/www/html/data /var/www/html/config
chown www-data:www-data /var/www/html/core/skeleton /var/www/html/build/integration/vendor /var/www/html/build/integration/composer.lock /var/www/html/build/integration/output /var/www/html/build/integration/work /var/www/html/core/skeleton /var/www/.composer/cache

echo "{}" > /var/www/html/build/integration/composer.lock

echo "Starting server using $SQL database…"

tail --follow --retry /var/log/nginx/*.log /var/log/cron/owncloud.log &

if [ -n "$S3" ]
then
	sed -i '/\/\/PLACEHOLDER/ r /root/s3.php' /var/www/html/config/config.php
fi

if [ -n "$SWIFT" ]
then
    sed -i '/\/\/PLACEHOLDER/ r /root/swift.php' /var/www/html/config/config.php
fi

if [ -n "$SWIFTV3" ]
then
    sed -i '/\/\/PLACEHOLDER/ r /root/swiftv3.php' /var/www/html/config/config.php
fi

if [ -n "$AZURE" ]
then
    sed -i '/\/\/PLACEHOLDER/ r /root/azure.php' /var/www/html/config/config.php
fi

/usr/sbin/cron -f &
/usr/bin/redis-server &
/usr/local/sbin/php-fpm &
/etc/init.d/nginx start
