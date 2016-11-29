# How to install keykeeper software on an APU2

dd an install-amd64-minimal-<date>.iso onto a USB stick, the
boot stick.

Copy a stage4 tarball from the build machine, as described in
bootstrap.md, to a filesystem on another USB stick.

Temporarily, until we've packaged the kernel a bit nicer: In addition
to that, copy the following files from FIXME to the stick:

    /boot/System.map-*4.7.10-hardened
    /boot/initramfs-*4.7.10-hardened
    /boot/kernel-*4.7.10-hardened
    /lib/modules/4.7.10-hardened

Connect the serial port to a terminal (program) and boot from the boot
stick by pressing F10, selecting the boot stick and entering
'gentoo-nofb console=ttyS0,115200' (or whatever speed your terminal
(program) is configured for).

    [
    livecd ~ # parted -a optimal /dev/sda
    GNU Parted 3.2
    Using /dev/sda
    Welcome to GNU Parted! Type 'help' to view a list of commands.
    (parted) unit mib
    (parted) mklabel gpt
    (parted) mkpart primary 1 3
    (parted) name 1 grub
    (parted) set 1 bios_grub on
    (parted) mkpart primary 3 131
    (parted) name 2 boot
    (parted) mkpart primary 131 -1
    (parted) name 3 rootfs
    (parted) q
    ]

    mkfs.ext2 /dev/sda2
    mkfs.ext4 /dev/sda3

    mount /dev/sda3 /mnt/gentoo
    mkdir /mnt/gentoo/boot
    mount /dev/sda2 /mnt/gentoo/boot

Insert "the other stick".

    mkdir /mnt2
    mount /dev/sdc1 /mnt2

date CURRENTDATEANDTIMEINUTC
cd /mnt/gentoo
tar xj -f /mnt2/stage4-amd64-keykeeper.*.tar.bz2 --xattrs
cp -a /mnt2/boot .
cp -a /mnt2/lib/modules/* /lib/modules/
mount -t proc proc proc; mount -R /dev dev; mount -R /sys sys
chroot .
. /etc/profile; export PS1="(chroot) $PS1"
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
passwd -d root
exit
umount -R boot proc sys dev
cd ..; umount gentoo
shutdown -r now
