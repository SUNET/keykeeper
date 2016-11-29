#!/bin/bash

cd /dev/shm
name=${1:-md-signer}
def_subject="/C=SE/ST=Stockholm/L=Stockholm/O=SUNET/OU=SWAMID/CN=SWAMID metadata signer v2.0"
subject=${2:-$def_subject}
days=${3:-7305}		# 20 years

pass=`openssl rand -base64 32 | tr -d /=+ | cut -c -40`

openssl genrsa -aes256 -passout pass:${pass} 4096 > ${name}.key
openssl req -x509 -sha256 -new -subj "${subject}" -days ${days} -passin pass:${pass} -key ${name}.key -out ${name}.crt
