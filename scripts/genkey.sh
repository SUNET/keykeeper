#!/bin/bash

cd /dev/shm

name="md-signer"
subject="/C=SE/ST=Stockholm/L=Stockholm/O=SUNET/OU=SWAMID/CN=SWAMID metadata signer v2.0"
days=7305	# 20 years

pass=`openssl rand -base64 32 | tr -d /=+ | cut -c -40`

openssl genrsa -aes256 -passout pass:${pass} 4096 > ${name}.key
openssl req -x509 -sha256 -new -subj "${subject}" -days ${days} -passin pass:${pass} -key ${name}.key -out ${name}.crt

