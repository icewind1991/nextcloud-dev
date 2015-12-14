FROM icewind1991/php7-nginx
MAINTAINER  Robin Appelman <robin@icewind.nl>
# MAINTAINER Robin Schneider <ypid@riseup.net>
# MAINTAINER silvio <silvio@port1024.net>
# MAINTAINER Josh Chaney <josh@chaney.io>

RUN DEBIAN_FRONTEND=noninteractive ;\
    apt-get update && \
    apt-get install --assume-yes \
        cron \
        redis-server \
        smbclient \
        sudo \
        wget \
        attr \
        git \
        phpunit

ADD configs/autoconfig_mysql.php configs/autoconfig_pgsql.php configs/autoconfig_oci.php /root/
ADD configs/nginx-app.conf /etc/nginx/

RUN mkdir --parent /var/log/cron
ADD configs/cron.conf /etc/oc-cron.conf
RUN crontab /etc/oc-cron.conf

ADD misc/bootstrap.sh misc/occ misc/tests /usr/local/bin/

ENTRYPOINT  ["bootstrap.sh"]
