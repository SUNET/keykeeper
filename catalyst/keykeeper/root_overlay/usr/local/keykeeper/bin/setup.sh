#!/bin/bash

export PATH=/usr/safenet/lunaclient/bin:$PATH

ip = $1

# configure Luna p2p network
(cd /etc/init.d ; test -h net.enp2s0 || ln -s net.lo net.enp2s0)
touch /etc/conf.d/net
grep -q config_enp2s0 /etc/conf.d/net || echo "config_enp2s0=\"${ip}/255.255.255.0\"" >> /etc/conf.d/net

# generate luna client certificate
vtl createCert -n "${ip}"
