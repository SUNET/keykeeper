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

# SUNET memcard-tools
emerge dev-vcs/git && ( cd /usr/src && git clone https://github.com/SUNET/memcard-tools && cd memcard-tools && make && make install )

# HW random number generator support
emerge sys-apps/rng-tools
rc-update add rngd default
cp $DIR/extras/rngd.conf /etc/conf.d/rngd

# Luna SA client
emerge rpm
rpm -i --nodeps $DIR/extras/luna/*.rpm
~                                                                                                                                 
