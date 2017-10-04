#!/bin/bash
# Configure CA setting
sed -i -e "s/cacert.pem/example-ca.crt/g" -e "s/cakey.pem/example-ca.key/g" /etc/pki/tls/openssl.cnf
# Generate certificate and private key
SUBJECT_PREFIX="/C=CN/ST=Shaanxi/L=Xi'an/O=Example, Inc."
DOMAIN="example.com"
PUBTLS=/var/www/html/pub/tls
mkdir -p ${PUBTLS}/{certs,private}
for SERVER in server www webapp; do
    SUBJECT="${SUBJECT_PREFIX}/CN=${SERVER}.${DOMAIN}"
    KEY="${PUBTLS}/private/${SERVER}.key"
    openssl req -new -nodes -out ${PUBTLS}/certs/${SERVER}.csr -keyout ${KEY} -days 3650 -subj "${SUBJECT}"
    openssl ca -batch -in ${PUBTLS}/certs/${SERVER}.csr -out ${PUBTLS}/certs/${SERVER}.crt
    ( cat ${KEY}; echo; cat ${PUBTLS}/certs/${SERVER}.csr ) > ${PUBTLS}/certs/${SERVER}.pem
    rm -fr ${PUBTLS}/certs/${SERVER}.csr
done
