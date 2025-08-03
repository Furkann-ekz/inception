FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php-fpm php-mysql php-cli php-curl php-gd php-mbstring php-xml php-xmlrpc \
    mariadb-client curl wget unzip less netcat

RUN mkdir -p /run/php

# wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./tools/WordPressInstaller.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 9000
ENTRYPOINT ["setup.sh"]
