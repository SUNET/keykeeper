#!/bin/sh

def_required=3
def_total=6
def_days=7305	# 20 years
def_name="md-signer"
def_subject="/C=SE/ST=Stockholm/L=Stockholm/O=SUNET/OU=SWAMID/CN=SWAMID metadata signer v2.0"
def_subject_short="signer v2.0"
def_device="/dev/sdb1"

help()
{
	echo "Usage: $0 [-d] <action> [args] ..."
	echo "Actions:"
	echo "  new [required:$def_required] [total:$def_total] [name:$def_name] [subject:...$def_subject_short] [days:$def_days]"
	echo "  use [name:$def_name]"
	echo "  backup [device:$def_device] [name:$def_name]"
	echo "  export [device:$def_device] [name:$def_name]"
	echo "  card-info"
	echo "  card-dup"
	echo "  ent"
	exit 1
}

swamid_new()
{
	echo "#"
	echo "# Generate certificate and save secret to cards"
	echo "#"

	keyshare new "$name" "$days" "$subject" "$required_parts" "$n_parts"

	echo "#"
	echo "# Certification information"
	echo "#"

	set -x
	ls -l $name*
	openssl x509 -in $name.crt
	openssl x509 -noout -in $name.crt -fingerprint -sha256
	openssl x509 -noout -in $name.crt -issuer -subject
	openssl x509 -noout -in $name.crt -text | grep -A2 Valid
	grep -- "-" $name.key
	set +x
}

swamid_use()
{
	echo "#"
	echo "# Decrypt key for usage and spawn shell"
	echo "#"

	keyshare use "$name"
}

swamid_card_info()
{
	echo "#"
	echo "# Print metadata about a card"
	echo "#"

	cardshare info
}

swamid_card_dup()
{
	echo "#"
	echo "# Duplicate/backup a card"
	echo "#"

	cardshare dup
}

swamid_backup()
{
	echo "#"
	echo "# Take backup of $name.crt and $name.key to $device"
	echo "#"
	echo -n "Insert backup USB stick and press return..."
	read x
	set -x
	echo copy
	sha256sum $name.crt $name.key
	mount $device /mnt || exit 1
	cp $name.crt $name.key /mnt || exit 1
	umount /mnt || exit 1

	echo verify
	mount $device /mnt || exit 1
	sha256sum /mnt/$name.crt /mnt/$name.key
	umount /mnt || exit 1
	set +x
}

swamid_export()
{
	echo "#"
	echo "# Export $name.crt to $device"
	echo "#"
	echo -n "Insert backup USB stick and press return..."
	read x
	set -x
	echo copy
	sha256sum $name.crt
	mount $device /mnt || exit 1
	cp $name.crt /mnt || exit 1
	umount /mnt || exit 1

	echo verify
	mount $device /mnt || exit 1
	sha256sum /mnt/$name.crt
	umount /mnt || exit 1
	set +x
}

swamid_ent()
{
	echo "#"
	echo "# Test random generator"
	echo "#"

	set -x
	ps auxww | grep '[r]ngd'
	dd if=/dev/urandom count=10 bs=1M | ent
	set +x
}

[ $# = 0 ] && help
if [ $1 = "-d" ] ; then
	CARD=console
	export CARD
	shift
	[ $# = 0 ] && help
fi
case $1 in
	new)
		required_parts=${2:-$def_required}
		n_parts=${3:-$def_total}
		name=${4:-$def_name}
		subject=${5:-$def_subject}
		days=${6:-$def_days}

		swamid_new || exit 1
		swamid_use || exit 1
		;;

	use)
		name=${2:-$def_name}
		swamid_use || exit 1
		;;
	backup)
		device=${2:-$def_device}
		name=${3:-$def_name}
		swamid_backup || exit 1
		;;
	export)
		device=${2:-$def_device}
		name=${3:-$def_name}
		swamid_export || exit 1
		;;
	card-info)
		swamid_card_info || exit 1
		;;
	card-dup)
		swamid_card_dup || exit 1
		;;
	ent)
		swamid_ent || exit 1
		;;
	--help|-h)
		help
		;;
	*)
		echo "Bad action: $1"
		help
		;;
esac

