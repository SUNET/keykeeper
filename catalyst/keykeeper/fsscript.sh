set -o errexit
set -o nounset

echo 'hostname="keykeeper"' > /etc/conf.d/hostname
cat /dev/null > /etc/issue
cp /usr/share/zoneinfo/Europe/Stockholm /etc/localtime

sed -i -e 's/^#s0:/s0:/1' /etc/inittab
sed -i -e 's|^\(s0:.*\) -L [0-9]*|\1 -L 19200|1' /etc/inittab
cat >> /etc/default/grub <<EOF
GRUB_TERMINAL=serial
GRUB_SERIAL_COMMAND="serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1"
GRUB_CMDLINE_LINUX="console=tty0 console=ttyS0,19200n8"
EOF

/usr/sbin/env-update

/usr/local/keykeeper/bin/install.sh
