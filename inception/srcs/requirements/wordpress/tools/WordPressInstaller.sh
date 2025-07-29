#!/bin/sh
set -ex

# MariaDB hazır olana kadar bekle
echo "⌛ MariaDB bekleniyor..."
until nc -z mariadb 3306; do
  echo "⏳ MariaDB hala hazır değil..."
  sleep 2
done

echo "✅ MariaDB erişilebilir durumda."

cd /var/www/html

# Eğer daha önce kurulmadıysa
if [ ! -f wp-config.php ]; then
  echo "⬇️ WordPress indiriliyor..."
  wp core download --allow-root

  echo "⚙️ wp-config.php oluşturuluyor..."
  wp config create \
    --dbname="$WP_DB_NAME" \
    --dbuser="$WP_DB_USER" \
    --dbpass="$WP_DB_PASSWORD" \
    --dbhost=mariadb \
    --allow-root

  echo "🚀 WordPress kurulumu yapılıyor..."
  wp core install \
    --url="$WP_SITE_URL" \
    --title="$WP_SITE_TITLE" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASS" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --skip-email \
    --allow-root

  echo "👤 Ek kullanıcı oluşturuluyor..."
  wp user create "$WP_EXTRA_USER" "$WP_EXTRA_EMAIL" \
    --user_pass="$WP_EXTRA_PASS" \
    --role=author \
    --allow-root
fi

echo "🧠 php-fpm başlatılıyor..."
php-fpm7.4 -F
