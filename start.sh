#!/bin/bash

set -eu -o pipefail

echo "Generating sogo.conf"

sed -e "s,##MYSQL_URL##,${MYSQL_URL}," \
    -e "s,##LDAP_URL##,${LDAP_URL}," \
    -e "s/##LDAP_BIND_DN##/${LDAP_BIND_DN}/" \
    -e "s/##LDAP_BIND_PASSWORD##/${LDAP_BIND_PASSWORD}/" \
    -e "s/##LDAP_USERS_BASE_DN##/${LDAP_USERS_BASE_DN}/" \
    -e "s/##SMTP_SERVER_URL##/${MAIL_SMTP_SERVER}/"\
    -e "s/##SMTP_SERVER_PORT##/${MAIL_SMTP_PORT}/"\
    -e "s/##IMAP_SERVER_URL##/${MAIL_IMAP_SERVER}/"\
    -e "s/##IMAP_SERVER_PORT##/${MAIL_IMAP_PORT}/"\
    /app/code/sogo.conf  > /run/sogo.conf

echo "Generating nginx.conf"

sed -e "s,##HOSTNAME##,${APP_DOMAIN}," \
    /app/code/nginx.conf  > /run/nginx.conf

echo "Make cloudron own /run"
chown -R cloudron:cloudron /run

echo "Start nginx"
nginx -c /run/nginx.conf &

echo "Start memcached"
memcached -u cloudron -v -m 32 &

echo "Start sogod"
exec /usr/local/bin/gosu cloudron:cloudron /usr/sbin/sogod
