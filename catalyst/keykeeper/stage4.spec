subarch: amd64
version_stamp: keykeeper-202203.05
target: stage4
profile: default/linux/amd64/17.1/no-multilib/hardened/selinux
rel_type: default
snapshot: 20220226
source_subpath: stage3-amd64-hardened-nomultilib-selinux-openrc-20220109T170538Z
portage_confdir: /home/catalyst/keykeeper/catalyst/keykeeper/portage
cflags: -O2 -pipe

stage4/use: acpi bzip2 cli crypt glib ipv6 llvm openssl posix readline ssl threads udev unicode usb zlib
stage4/packages: sys-boot/grub sys-apps/rng-tools sys-apps/usbutils app-arch/rpm dev-libs/openssl sci-mathematics/ent sys-auth/ykpers app-editors/vim
stage4/fsscript: /home/catalyst/keykeeper/catalyst/keykeeper/fsscript.sh
stage4/root_overlay: /home/catalyst/keykeeper/catalyst/keykeeper/root_overlay
stage4/unmerge: help2man
stage4/empty: /usr/src /usr/include /usr/share/doc /usr/share/genkernel /usr/share/texinfo /usr/share/man /usr/share/sgml /var/cache /var/db/repos/gentoo

boot/kernel: keykeeper
boot/kernel/keykeeper/sources: gentoo-sources
boot/kernel/keykeeper/config: linux-config-5.15.11-APU2
