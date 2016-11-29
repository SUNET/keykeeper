#!/bin/sh

DIR=$(pwd)

# PCSC-lite && ACS card reader driver
rc-update add pcscd default 
(
tar -C /usr/src -xvz -f $DIR/extras/acsccid-1.1.3.tar.gz 
cd /usr/src/acsccid-1.1.3 && ./bootstrap && ./configure && make && make install 
cp src/92_pcscd_acsccid.rules /etc/udev/rules.d 
cp $DIR/extras/Info.plist /usr/lib64/readers/usb/ifd-acsccid.bundle/Contents/Info.plist 
)

# HW random number generator support
rc-update add rngd default
cp $DIR/extras/rngd.conf /etc/conf.d/rngd
cp $DIR/extras/99_ldattach_rngd.rules /etc/udev/rules.d

# Luna SA client
rpm -i --nodeps $DIR/extras/luna/*.rpm
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

# python & dependencies
pip install extras/wheels/*.whl
