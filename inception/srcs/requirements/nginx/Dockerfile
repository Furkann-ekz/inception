FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl

COPY ./tools/installer.sh /installer.sh
COPY ./conf/default.conf /etc/nginx/sites-available/default
RUN chmod +x /installer.sh

EXPOSE 443

ENTRYPOINT ["/installer.sh"]
