#!/bin/sh

touch /var/log/nginx/access.log
touch /var/log/nginx/error.log
touch /var/log/cron/owncloud.log

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

echo "Starting server using $SQL database…"

tail --follow --retry /var/log/nginx/*.log /var/log/cron/owncloud.log &

/usr/sbin/cron -f &
/usr/bin/redis-server &
/usr/local/sbin/php-fpm &
/etc/init.d/nginx start
