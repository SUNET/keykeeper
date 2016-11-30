#!/bin/sh

def_required=3
def_total=7
def_days=7305	# 20 years
def_name="md-signer"
def_subject="/C=SE/ST=Stockholm/L=Stockholm/O=SUNET/OU=SWAMID/CN=SWAMID metadata signer v2.0"
def_subject_short="signer v2.0"


help()
{
	echo "Usage: $0 [-d] <action> [args] ..."
	echo "Actions:"
	echo "  new [required:$def_required] [total:$def_total] [name:$def_name] [subject:...$def_subject_short] [days:$def_days]"
	echo "  use [name:$def_name]"
	echo "  info"
	echo "  dup"
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

	ls -l $name*
	grep -- "-" $name.key
	openssl x509 -noout -in $name.crt -issuer -subject
	openssl x509 -noout -in $name.crt -text | grep -A2 Valid
	openssl x509 -noout -in $name.crt -fingerprint -md5
	openssl x509 -noout -in $name.crt -fingerprint -sha1
	openssl x509 -noout -in $name.crt -fingerprint -sha256
}

swamid_use()
{
	echo "#"
	echo "# Decrypt key for usage and spawn shell"
	echo "#"

	keyshare use "$name"
}

swamid_info()
{
	echo "#"
	echo "# Print metadata about a card"
	echo "#"

	cardshare info
}

swamid_dup()
{
	echo "#"
	echo "# Duplicate/backup a card"
	echo "#"

	cardshare dup
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

		swamid_new
		swamid_use
		;;

	use)
		name=${2:-$def_name}
		swamid_use
		;;
	info)
		swamid_info
		;;
	dup)
		swamid_dup
		;;
	--help|-h)
		help
		;;
	*)
		echo "Bad action: $1"
		help
		;;
esac

