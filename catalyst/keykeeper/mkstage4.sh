#! /bin/sh
n=stage4-amd64-keykeeper.201611
rm -f /var/tmp/catalyst/tmp/default/.autoresume-$n/{chroot_setup,setup_confdir,build_packages}
ln -sf /var/tmp/catalyst/builds/default/$n.tar.bz2
[ -L tmp ] && rm tmp; ln -sf /var/tmp/catalyst/tmp/default/$n tmp
time catalyst -c catalyst.conf -f stage4.spec
