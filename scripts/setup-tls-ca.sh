#!/bin/bash
# Prepare cadir
cadir=/etc/pki/CA/
mkdir -p ${cadir}/{certs,crl,newcerts}
touch ${cadir}/index.txt
touch ${cadir}/serial
echo 01 > ${cadir}/serial
# Generate CA certificate and private key
openssl req -days 3650 -new -x509 -nodes -out ${cadir}/example-ca.crt -keyout ${cadir}/private/example-ca.key -subj "/C=CN/ST=Shaanxi/L=Xi'an/O=Example, Inc./CN=example.com Certificate Authority"
# Expose CA cert 
cp ${cadir}/example-ca.crt /etc/pki/tls/certs
cp ${cadir}/example-ca.crt /var/www/html/pub/
cp /var/www/html/pub/example-ca.crt /var/www/html/pub/EXAMPLE-CA-CRT
