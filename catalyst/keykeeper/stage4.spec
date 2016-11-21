subarch: amd64
version_stamp: keykeeper.201611
target: stage4
profile: hardened/linux/amd64/no-multilib
rel_type: hardened
snapshot: /usr
source_subpath: hardened/stage3-amd64-hardened+nomultilib-FIXME
portage_confdir: /etc/catalyst/keykeeper/portage
cflags: -O2 -pipe

stage4/use: -* acpi bzip2 cli crypt glib ipv6 llvm openssl posix readline ssl threads udev unicode usb zlib
stage4/packages: -avt openntpd openssh less
stage4/fsscript: /etc/catalyst/keykeeper/fsscript.sh
stage4/root_overlay: /etc/catalyst/keykeeper/root_overlay
stage4/unmerge: nano help2man
