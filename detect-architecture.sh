#!/bin/sh

# TODO: support for arm64/armel/armhf, at least for:
#       - Raspberry Pi
#       - AWS A1 instances

if [ "`uname -m`" = "x86_64" ]; then
	echo "amd64"
else
	echo "i386"
fi
