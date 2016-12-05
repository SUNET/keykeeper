all: version sums

version:
	git describe HEAD > catalyst/keykeeper/root_overlay/etc/issue.keykeeper

sums:
	find catalyst/keykeeper/root_overlay -type f -print0 | xargs --null sha512sum | gpg --clearsign > sums_signed.txt
	git commit -m "updated sums_signed.txt" sums_signed.txt
