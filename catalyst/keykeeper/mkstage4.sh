#! /bin/sh
set -eu

D="$1"; shift  # example: /home/catalyst/var-tmp
N=$(egrep ^version_stamp: stage4.spec | cut -d ' ' -f 2)
FN="stage4-amd64-$N"

[ -d $D ]
rm -f ${D}/tmp/default/.autoresume-$FN/{chroot_setup,setup_confdir,build_packages}
ln -sf ${D}/builds/default/$FN.tar.bz2
[ -L tmp ] && rm tmp; ln -sf ${D}/tmp/default/$FN tmp

catalyst -c catalyst.conf -f stage4.spec $@
