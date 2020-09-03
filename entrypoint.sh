#!/bin/bash
set -e
if [ -f /etc/apache2/sites-available/vhost-website.conf ]; then
 rm /etc/apache2/sites-available/vhost-website.conf
fi

if [ -z "$USER_CURRENT_ID" ]; then
	USER_CURRENT_ID="www-data"
fi
if [ -z "$USER_CURRENT_GID" ]; then
	USER_CURRENT_GID="www-data"
fi

cat <<EOF > /etc/php/$PHPVERSION/fpm/pool.d/www.conf
[www]

user = $USER_CURRENT_ID
group = $USER_CURRENT_GID

listen = 9000
listen.owner = $USER_CURRENT_ID
listen.group = $USER_CURRENT_GID

pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
chdir = /var/www
php_admin_value[sendmail_path] = "/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025"
EOF

exec "$@"