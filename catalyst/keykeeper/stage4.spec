subarch: amd64
version_stamp: keykeeper.201611
target: stage4
profile: hardened/linux/amd64/no-multilib
rel_type: hardened
snapshot: 20161128
source_subpath: hardened/stage3-amd64-hardened+nomultilib-20161124
portage_confdir: /etc/catalyst/keykeeper/portage
cflags: -O2 -pipe

stage4/use: acpi bzip2 cli crypt glib ipv6 llvm openssl posix readline ssl threads udev unicode usb zlib
stage4/packages: sys-devel/bc sys-boot/grub:2 app-crypt/ccid sys-apps/rng-tools sys-apps/usbutils app-arch/rpm dev-python/pip dev-libs/openssl dev-lang/swig sci-mathematics/ent sys-fs/cryptsetup
stage4/fsscript: /etc/catalyst/keykeeper/fsscript.sh
stage4/root_overlay: /etc/catalyst/keykeeper/root_overlay
stage4/unmerge: help2man

boot/kernel: keykeeper
stage4/gk_mainargs: --lvm --luks
boot/kernel/keykeeper/sources: hardened-sources
boot/kernel/keykeeper/config: /etc/catalyst/keykeeper/linux-config-4.7.10-hardened
#boot/kernel/keykeeper/extraversion: keykeeper
