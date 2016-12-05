all: sums

sums:
	find catalyst/keykeeper/root_overlay -type f | xargs sha512sum | gpg --clearsign > sums_signed.txt
	git commit -m "updated sums_signed.txt" sums_signed.txt
