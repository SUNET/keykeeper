cat << EOF > /etc/conf.d/net
config_enp1s0=("dhcp")
config_enp2s0="10.0.0.2/24"
EOF
echo 'hostname="keykeeper"' > /etc/conf.d/hostname
cat /dev/null > /etc/issue
cp /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
mkdir /root/.ssh; chmod 700 /root/.ssh
cat << EOF > /root/.ssh/authorized_keys
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID4bv1RXziZSjHkKY5kDbxboNUGkHEpBivdX8fdvl7Zt
EOF
env-update
exit 0