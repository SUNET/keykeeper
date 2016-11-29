#!/bin/sh

DIR=$(pwd)

# PCSC-lite && ACS card reader driver
emerge app-crypt/ccid 
rc-update add pcscd default 
(
tar -C /usr/src -xvz -f $DIR/extras/acsccid-1.1.3.tar.gz 
cd /usr/src/acsccid-1.1.3 && ./bootstrap && ./configure && make && make install 
cp src/92_pcscd_acsccid.rules /etc/udev/rules.d 
cp $DIR/extras/Info.plist /usr/lib64/readers/usb/ifd-acsccid.bundle/Contents/Info.plist 
)

# HW random number generator support
emerge sys-apps/rng-tools
emerge sys-apps/usbutils
rc-update add rngd default
cp $DIR/extras/rngd.conf /etc/conf.d/rngd
cp $DIR/extras/99_ldattach_rngd.rules /etc/udev/rules.d

# Luna SA client
emerge rpm
rpm -i --nodeps $DIR/extras/luna/*.rpm

# configure Luna p2p network
(cd /etc/init.d ; test -h net.enp2s0 || ln -s net.lo net.enp2s0)
touch /etc/conf.d/net
grep -q config_enp2s0 /etc/conf.d/net || echo "config_enp2s0=\"10.0.0.2/255.255.255.0\"" >> /etc/conf.d/net

# python & dependencies (secretsharing)
emerge dev-python/pip # pulls in python
pip install extras/wheels/*.whl

# openssl
emerge openssl
