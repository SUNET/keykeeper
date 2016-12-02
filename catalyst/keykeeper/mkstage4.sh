#! /bin/sh
n=stage4-amd64-keykeeper.201612
rm -f /var/tmp/catalyst/tmp/hardened/.autoresume-$n/{chroot_setup,setup_confdir,build_packages}
ln -sf /var/tmp/catalyst/builds/hardened/$n.tar.bz2
[ -L tmp ] && rm tmp; ln -sf /var/tmp/catalyst/tmp/hardened/$n tmp
time catalyst -c catalyst.conf -f stage4.spec $@
