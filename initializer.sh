#!/bin/sh

# Set permissions for directories and files
chown -R nginx:nginx /var/www/html

find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;
chmod -R 775 /var/www/html/storage
chmod -R 775 /var/www/html/bootstrap/cache