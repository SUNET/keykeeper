#!/bin/sh

set -o errexit
set -o nounset

DIR=/usr/local/keykeeper

# ACS card reader driver.
(
    tar -C /usr/src -xz -f $DIR/distfiles/acsccid-1.1.3.tar.gz
    cd /usr/src/acsccid-1.1.3
    ./bootstrap
    ./configure
    make
    make install
    cp src/92_pcscd_acsccid.rules /etc/udev/rules.d/
    cp $DIR/distfiles/Info.plist /usr/lib64/readers/usb/ifd-acsccid.bundle/Contents/Info.plist
)

# pyscard.
(
    tar -C /usr/src -xz -f $DIR/distfiles/pyscard-1.9.4.tar.xz
    cd /usr/src/pyscard-1.9.4
    python setup.py install
)
