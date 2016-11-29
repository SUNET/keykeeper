set -o errexit
set -o nounset

cat << EOF > /etc/conf.d/net
config_enp1s0=("dhcp")
config_enp2s0="10.0.0.2/24"
EOF
echo 'hostname="keykeeper"' > /etc/conf.d/hostname
cat /dev/null > /etc/issue
cp /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
[ -d /root/.ssh ] || mkdir /root/.ssh; chmod 700 /root/.ssh
cat << EOF > /root/.ssh/authorized_keys
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID4bv1RXziZSjHkKY5kDbxboNUGkHEpBivdX8fdvl7Zt
EOF

sed -i -e 's|^\(s0:.*\) -L [0-9]*|\1 -L 9600|1' /etc/inittab
cat >> /etc/default/grub <<EOF
# Console on serial.
GRUB_TERMINAL=serial
GRUB_CMDLINE_LINUX="console=tty0 console=ttyS0,115200n8"
GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"
EOF

env-update

/usr/local/keykeeper/bin/install.sh
