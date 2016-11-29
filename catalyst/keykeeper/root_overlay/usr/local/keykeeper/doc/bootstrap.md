# Bootstrap

Here is how to set up a keykeeper machine for Sunet.

1. Install a build machine, as described in doc/install-buildmachine.txt.

1. Make a stage4 tarball, as described in catalyst/README.

1. Boot the target machine and install thestage4 from the previous
   step as described in doc/install-apu2.md.

1. Build the software needed for key generation and key exporting by
   invoking /usr/local/keykeeper/bin/install.sh.

1. Set up HSM communication by invoking /usr/local/keykeeper/bin/setup.sh.

# Log

## 2016-11-??

Notes on how FIXME:hostname was installed.
