#!/bin/sh

set -o errexit
set -o nounset

DIR=/usr/local/keykeeper

# Enable PCSC-lite
rc-update add pcscd default 

# HW random number generator support
rc-update add rngd default
cp $DIR/distfiles/rngd.conf /etc/conf.d/rngd
cp $DIR/distfiles/99_ldattach_rngd.rules /etc/udev/rules.d

# Luna SA client
rpm -i --nodeps $DIR/distfiles/luna/*.rpm || true
cat<<EOF>/etc/Chrystoki.conf
Chrystoki2 = {
   LibUNIX = /usr/lib/libCryptoki2.so;
   LibUNIX64 = /usr/lib/libCryptoki2_64.so;
}

Luna = {
  DefaultTimeOut = 500000;
  PEDTimeout1 = 100000;
  PEDTimeout2 = 200000;
  PEDTimeout3 = 10000;
  KeypairGenTimeOut = 2700000;
  CloningCommandTimeOut = 300000;
  CommandTimeOutPedSet = 720000;
}

LunaSA Client = {
   ReceiveTimeout = 20000;
   SSLConfigFile = /usr/safenet/lunaclient/bin/openssl.cnf;
   ClientPrivKeyFile = /usr/safenet/lunaclient/cert/client/ClientKey.pem;
   ClientCertFile = /usr/safenet/lunaclient/cert/client/Client.pem;
}

CardReader = {
  RemoteCommand = 1;
}

Misc = {
  PE1746Enabled = 0;
}
EOF

# add HSM server public keys
export PATH=/usr/safenet/lunaclient/bin:$PATH
vtl addServer -n se-tug-hsm1 $DIR/distfiles/se-tug-hsm1.sunet.se.crt
vtl addServer -n se-fre-hsm1 $DIR/distfiles/se-fre-hsm1.sunet.se.crt

# Secret sharing
pip install $DIR/distfiles/wheels/pycardshare-*.whl
pip install $DIR/distfiles/wheels/secretsharing-*.whl

# Symlink useful scripts to directory in PATH
ln -s $DIR/bin/swamid.sh /usr/local/bin/swamid
