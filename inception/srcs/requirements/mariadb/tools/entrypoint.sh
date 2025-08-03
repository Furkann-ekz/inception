#!/bin/sh
set -ex

DB_NAME="${MYSQL_DATABASE}"
DB_USER="${MYSQL_USER}"
DB_PASSWORD="${MYSQL_PASSWORD}"
DB_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD}"

echo "🚨 entrypoint.sh çalıştı 🚨"

# Eğer veritabanı ilk kez kuruluyorsa
if [ ! -f /var/lib/mysql/ibdata1 ]; then
  echo "✅ İlk MariaDB kurulumu yapılıyor..."
  mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# MariaDB'yi başlat
mysqld_safe --datadir=/var/lib/mysql &

# MariaDB hazır olana kadar bekle
until mysqladmin ping --silent; do
  echo "⏳ MariaDB başlatılıyor..."
  sleep 1
done

# Kullanıcı ve veritabanı oluştur
echo "✅ Veritabanı ve kullanıcılar oluşturuluyor..."
mysql -u root <<EOSQL
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
DROP USER IF EXISTS '${DB_USER}'@'%';
CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOSQL

# MariaDB'yi düzgün şekilde durdur
mysqladmin shutdown

sleep 3

# Kalıcı başlat
echo "🚀 MariaDB normal başlatılıyor..."
exec mysqld_safe --datadir=/var/lib/mysql
