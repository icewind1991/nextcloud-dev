#!/bin/sh

touch /var/log/nginx/access.log
touch /var/log/nginx/error.log
touch /var/log/cron/owncloud.log

cp /root/nginx.conf /etc/nginx/nginx.conf

if [ "$SQL" = "mysql" ]
then
	cp /root/autoconfig_mysql.php /var/www/owncloud/config/autoconfig.php
fi

if [ "$SQL" = "pgsql" ]
then
	cp /root/autoconfig_pgsql.php /var/www/owncloud/config/autoconfig.php
fi

if [ "$SQL" = "oci" ]
then
	cp /root/autoconfig_oci.php /var/www/owncloud/config/autoconfig.php
fi

if [ "${OWNCLOUD_IN_ROOTPATH}" = "1" ]
then
    sed --in-place "s#-x-replace-oc-rootpath-#/var/www/owncloud/#" /etc/nginx/nginx.conf
else
    sed --in-place "s#-x-replace-oc-rootpath-#/var/www/#" /etc/nginx/nginx.conf
fi

chown -R www-data:www-data /var/www/owncloud/data /var/www/owncloud/config

echo "Starting server using $SQL database…"

tail --follow --retry /var/log/nginx/*.log /var/log/cron/owncloud.log &

/usr/sbin/cron -f &
/usr/bin/redis-server &
/usr/local/sbin/php-fpm &
/etc/init.d/nginx start
