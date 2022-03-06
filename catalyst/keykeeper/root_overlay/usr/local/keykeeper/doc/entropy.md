rngd needs /dev/ttyUSB0 to be present when starting.

If the entropy source is not present at boot, or if the entropy source is not initialised early enough, starting rngd can be done like this:

    rc-service rngd start

Verify the quality of the entropy source by running ent(1) on its output:

    dd if=/dev/ttyUSB0 bs=4000 count=250 iflag=fullblock | ent

Reported entropy should be very close to 8.000000 bits/byte and the arithmetic mean value should be close to 127.5.
Compression should not reduce the size at all and the Monte Carlo value for Pi should be off by less than 0.05%.

Reasons for failure include entropy source not being initalised properly. Look for running ldattach processes and run ldattach manually in case there are none:

    /usr/sbin/ldattach -8 -n -1 -s 921600 tty /dev/ttyUSB0

Note that rngd requires the device to be ttyUSB0. Change this by editing /etc/conf.d/rngd if need be, and restart rngd.

