#!/bin/bash

cd /dev/shm
name=$1
def_subject="/CN=${name}"
subject=${2:-$def_subject}
days=${3:-"3650"}

pass=`openssl rand -base64 32 | tr -d /=+ | cut -c -40`

openssl genrsa -aes256 -passout pass:${pass} 4096 > ${name}.key
openssl req -x509 -sha256 -days $days -new -subj ${subject} -passin pass:${pass} -key ${name}.key -out ${name}.crt

