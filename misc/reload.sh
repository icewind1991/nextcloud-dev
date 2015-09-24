 
#!/bin/bash

set -e

# watch for changes in /mnt and update nginx if there is one on /mnt/proxy
while true; do 
    inotifywait -r -e close_write,moved_to,create /owncloud-shared
    mount -o remount /var/www/owncloud
done