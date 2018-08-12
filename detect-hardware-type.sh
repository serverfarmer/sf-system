#!/bin/sh

if [ -f /proc/1/environ ] && grep -q lxc /proc/1/environ; then
	echo "lxc"
elif [ -f /run/systemd/container ] && grep -q lxc /run/systemd/container; then
	echo "lxc"

elif [ -f /run/systemd/container ] && grep -q systemd-nspawn /run/systemd/container; then
	echo "container"  # nspawn
elif [ -d /proc/vz ] && [ ! -f /proc/vz/version ]; then
	echo "container"  # openvz
elif [ -f /proc/self/status ] && grep -iq vxid /proc/self/status; then
	echo "container"  # linux-vserver

elif [ -d /sys/class/dmi/id ] && grep -q "Amazon EC2" /sys/class/dmi/id/*_vendor; then
	echo "guest"      # kvm/qemu or xen

elif [ -f /sys/devices/virtual/dmi/id/product_name ] && grep -q VirtualBox /sys/devices/virtual/dmi/id/product_name; then
	echo "guest"      # virtualbox
elif [ -d /sys/class/dmi/id ] && grep -q innotek /sys/class/dmi/id/*_vendor; then
	echo "guest"      # virtualbox
elif [ -f /proc/scsi/scsi ] && grep -iq "VBOX HARDDISK" /proc/scsi/scsi; then
	echo "guest"      # virtualbox

elif [ -f /proc/scsi/scsi ] && grep -iq vmware /proc/scsi/scsi; then
	echo "guest"      # vmware
elif [ -d /sys/class/dmi/id ] && egrep -q "(VMware|VMW)" /sys/class/dmi/id/*_vendor; then
	echo "guest"      # vmware

elif [ -x /usr/bin/lspci ] && [ "`/usr/bin/lspci |grep Hyper-V`" != "" ]; then
	echo "guest"      # ms hyper-v
elif [ -d /sys/class/dmi/id ] && grep -q "Microsoft Corporation" /sys/class/dmi/id/*_vendor; then
	echo "guest"      # ms virtualpc or hyper-v

elif [ -f /proc/cpuinfo ] && grep -q "QEMU Virtual CPU" /proc/cpuinfo; then
	echo "guest"      # kvm/qemu
elif [ -f /proc/scsi/scsi ] && grep -iq QEMU /proc/scsi/scsi; then
	echo "guest"      # kvm/qemu
elif [ -d /sys/class/dmi/id ] && grep -q QEMU /sys/class/dmi/id/*_vendor; then
	echo "guest"      # kvm/qemu
elif [ -d /sys/class/dmi/id ] && grep -q Google /sys/class/dmi/id/*_vendor; then
	echo "guest"      # kvm/qemu
elif [ -d /dev/disk/by-id ] && [ "`ls /dev/disk/by-id/ata-* 2>/dev/null |grep QEMU_HARDDISK`" != "" ]; then
	echo "guest"      # kvm/qemu

elif [ -d /sys/class/dmi/id ] && grep -q Xen /sys/class/dmi/id/*_vendor; then
	echo "guest"      # xen
elif [ -f /proc/xen/capabilities ]; then
	echo "guest"      # xen
elif [ -f /sys/hypervisor/type ] && grep -iq xen /sys/hypervisor/type; then
	echo "guest"      # xen

elif [ -d /sys/class/dmi/id ] && grep -q Bochs /sys/class/dmi/id/*_vendor; then
	echo "guest"      # bochs
elif [ -f /proc/cpuinfo ] && grep -q "User Mode Linux" /proc/cpuinfo; then
	echo "guest"      # uml

elif [ -f /proc/sysinfo ] && grep -q QNAP /proc/sysinfo; then
	echo "oem"        # qnap

elif [ "`dmesg |grep -v 'db cert' |grep VirtualBox`" != "" ]; then
	echo "guest"      # virtualbox
elif [ "`dmesg |grep -v 'db cert' |grep VBOX`" != "" ]; then
	echo "guest"      # virtualbox
elif [ "`dmesg |grep -v 'db cert' |grep VMware`" != "" ]; then
	echo "guest"      # vmware
elif [ "`dmesg |grep -v 'db cert' |grep Hyper-V`" != "" ]; then
	echo "guest"      # ms hyper-v
elif [ "`dmesg |grep -v 'db cert' |grep QEMU`" != "" ]; then
	echo "guest"      # kvm/qemu
elif [ "`dmesg |grep -v 'db cert' |grep KVM`" != "" ]; then
	echo "guest"      # kvm/qemu
else
	echo "physical"
fi
