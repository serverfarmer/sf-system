#!/bin/sh

mach=`uname -m`

if [ "$mach" = "x86_64" ]; then
	echo "amd64"
elif [ "$mach" = "aarch64" ]; then  # Allwinner H5 (eg. NanoPi NEO2), Amazon EC2 A1 instances
	echo "arm64"
elif [ "$mach" = "armv7l" ]; then  # Raspberry Pi
	echo "armhf"
elif [ "$mach" = "armv5tel" ]; then  # QNAP TS-410
	echo "armel"
else
	echo "i386"
fi
