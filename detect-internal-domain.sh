#!/bin/sh
# Try to detect the local domain using DNS suffix got from DHCP options:
# - used especially in physical networks, and all other kinds of networks, when the staff has full control over the network and DHCP configuration
# - avoid it at least in AWS environment, otherwise it would return domain that is not user-maintainable
# - empty value is a safe default

if [ -d /sys/class/dmi/id ] && grep -qi amazon /sys/class/dmi/id/* 2>/dev/null; then
	:
elif [ -e /etc/resolv.conf ]; then
	grep ^search /etc/resolv.conf |awk '{ print $2 }'
fi
