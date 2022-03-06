#!/bin/sh

set -o errexit
set -o nounset

DIR=/usr/local/keykeeper

# HW random number generator support
rc-update add rngd default
cp $DIR/distfiles/rngd.conf /etc/conf.d/rngd
cp $DIR/distfiles/99_ldattach_rngd.rules /etc/udev/rules.d/

# Luna SA client
rpm -i --nodeps $DIR/distfiles/luna72/*.rpm || true
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
   NetClient = 1;
   ReceiveTimeout = 20000;
   SSLConfigFile = /usr/safenet/lunaclient/bin/openssl.cnf;
   ClientPrivKeyFile = /usr/safenet/lunaclient/cert/client/10.0.0.1Key.pem;
   ClientCertFile = /usr/safenet/lunaclient/cert/client/10.0.0.1.pem;
   ServerCAFile = /usr/safenet/lunaclient/cert/server/CAFile.pem;
}

CardReader = {
  RemoteCommand = 1;
}

Misc = {
  PE1746Enabled = 0;
  ToolsDir = /usr/safenet/lunaclient/bin;
}
EOF

# Add HSM server public keys and configuration.
# WARNING: Executing binary blobs on build machine.
export PATH=/usr/safenet/lunaclient/bin:$PATH
vtl addServer -n 10.0.0.1 -c $DIR/distfiles/tug-hsm2.sunet.se.pem
