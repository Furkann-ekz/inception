#!/bin/sh
set -ex

echo "Waiting for mariadb"
until nc -z mariadb 3306; do
  echo "Mariadb is not ready."
  sleep 2
done

cd /var/www/html

if [ ! -f wp-config.php ]; then
  echo "Downloading wordpress"
  wp core download --allow-root

  echo "wp-config.php creating"
  wp config create \
    --dbname="$WP_DB_NAME" \
    --dbuser="$WP_DB_USER" \
    --dbpass="$WP_DB_PASSWORD" \
    --dbhost=mariadb \
    --allow-root

  echo "start to wordpress setup"
  wp core install \
    --url="$WP_SITE_URL" \
    --title="$WP_SITE_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASS" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --skip-email \
    --allow-root

  wp user create "$WP_EXTRA_USER" "$WP_EXTRA_EMAIL" \
    --user_pass="$WP_EXTRA_PASS" \
    --role=author \
    --allow-root
fi

echo "start to php-fpm"
php-fpm7.4 -F
