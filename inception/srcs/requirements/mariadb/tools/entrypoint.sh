#!/bin/sh
set -ex

DB_NAME="${MYSQL_DATABASE}"
DB_USER="${MYSQL_USER}"
DB_PASSWORD="${MYSQL_PASSWORD}"
DB_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD}"


if [ ! -f /var/lib/mysql/ibdata1 ]; then
  echo "First mariadb setup is starting"
  mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

mysqld_safe --datadir=/var/lib/mysql &

until mysqladmin ping --silent; do
  echo "Waiting for mariadb"
  sleep 1
done

echo "start to creating database and users"
mysql -u root <<EOSQL
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
DROP USER IF EXISTS '${DB_USER}'@'%';
CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOSQL

mysqladmin shutdown

sleep 3

echo "Mariadb ok."
exec mysqld_safe --datadir=/var/lib/mysql
