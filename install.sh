#!/bin/sh

DIR=$(pwd)

emerge dev-vcs/git
emerge app-crypt/ccid
rc-update add pcscd default
( cd /usr/src && git clone https://github.com/SUNET/memcard-tools && cd memcard-tools && make && make install )
( tar -C /usr/src -xvz -f $DIR/extras/acsccid-1.1.3.tar.gz && cd /usr/src/acsccid-1.1.3 && ./bootstrap && ./configure && make && make install && cp src/92_pcscd_acsccid.rules /etc/udev/rules.d && cp $DIR/extras/Info.plist /usr/lib64/readers/usb/ifd-acsccid.bundle/Contents/Info.plist )
