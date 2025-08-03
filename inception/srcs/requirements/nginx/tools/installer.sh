#!/bin/bash
set -e

CERT_DIR="/etc/ssl/certs"
KEY_DIR="/etc/ssl/private"
DOMAIN="${DOMAIN_NAME}"

mkdir -p ${CERT_DIR} ${KEY_DIR}

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout ${KEY_DIR}/${DOMAIN}.key \
  -out ${CERT_DIR}/${DOMAIN}.crt \
  -subj "/C=TR/ST=Istanbul/L=42School/O=Inception/CN=${DOMAIN}"

echo "Starting nginx with TLS for ${DOMAIN}"
exec nginx -g "daemon off;"