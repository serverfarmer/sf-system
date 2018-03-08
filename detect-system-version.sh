#!/bin/sh

detect_os_type()
{
	if [ -f /etc/debian_version ] || [ -f /etc/devuan_version ]; then
		echo "debian"
	elif [ -f /etc/redhat-release ]; then
		echo "redhat"
	elif [ -f /etc/os-release ] && [ -f /etc/image-id ]; then
		echo "amazon"
	elif [ -f /etc/SuSE-release ]; then
		echo "suse"
	elif [ -f /etc/slackware-version ]; then
		echo "slackware"
	elif [ -f /etc/freebsd-update.conf ]; then
		echo "freebsd"
	elif [ -x /netbsd ]; then
		echo "netbsd"
	elif [ -f /bsd ] && [ -f /bsd.rd ]; then
		echo "openbsd"
	elif [ -f /etc/config/qpkg.conf ]; then
		echo "qnap"
	else
		echo "generic"
	fi
}

detect_debian_raw_version()
{
	DATA=`cat /etc/debian_version`
	case "$DATA" in
		4.0)
			echo "debian-etch"
			;;
		5.0 | 5.0.? | 5.0.1?)
			echo "debian-lenny"
			;;
		6.0 | 6.0.? | 6.0.1?)
			echo "debian-squeeze"
			;;
		7.? | 7.1?)
			echo "debian-wheezy"
			;;
		8.? | 8.1?)
			echo "debian-jessie"
			;;
		9.?)
			echo "debian-stretch"
			;;
		*)
			echo "debian-generic"
			;;
	esac
}

detect_redhat_raw_version()
{
	DATA=`cat /etc/redhat-release`
	case "$DATA" in
		"CentOS release 5.10 (Final)" | "CentOS release 5.11 (Final)")
			echo "redhat-centos5"
			;;
		"CentOS release 6.4 (Final)" | "CentOS release 6.5 (Final)" | "CentOS release 6.6 (Final)" | "CentOS release 6.7 (Final)" | "CentOS release 6.8 (Final)" | "CentOS release 6.9 (Final)")
			echo "redhat-centos6"
			;;
		"CentOS Linux release 7.0.1406 (Core) " | "CentOS Linux release 7.1.1503 (Core) ")
			echo "redhat-centos7"
			;;
		"Red Hat Enterprise Linux Server release 5.5 (Tikanga)")
			echo "redhat-rhel5"
			;;
		"Red Hat Enterprise Linux Server release 6.6 (Santiago)")
			echo "redhat-rhel6"
			;;
		"Red Hat Enterprise Linux Server release 7.1 (Maipo)")
			echo "redhat-rhel7"
			;;
		*)
			echo "redhat-generic"
			;;
	esac
}

detect_debian_version()
{
	if [ -f /etc/lsb-release ]; then
		. /etc/lsb-release
		if [ "$DISTRIB_ID" = "Ubuntu" ] && [ "$DISTRIB_CODENAME" != "" ]; then
			if [ -f /var/lib/zentyal/latestversion ]; then
				VER=`cat /var/lib/zentyal/latestversion |sed s/\\\.//g |cut -c1-2`
				echo "ubuntu-$DISTRIB_CODENAME-zentyal$VER"
			else
				echo "ubuntu-$DISTRIB_CODENAME"
			fi
		else
			echo "ubuntu-generic"
		fi

	elif [ -f /etc/rpi-issue ]; then
		DATA=`cat /etc/debian_version`
		case "$DATA" in
			8.?)
				echo "raspbian-jessie"
				;;
			*)
				echo "raspbian-generic"
				;;
		esac

	elif [ -f /etc/devuan_version ]; then
		DATA=`cat /etc/devuan_version`
		case "$DATA" in
			jessie)
				echo "devuan-jessie"
				;;
			*)
				echo "devuan-generic"
				;;
		esac

	elif [ -f /etc/pve/.version ]; then
		echo "`detect_debian_raw_version`-pve"
	elif [ -d /usr/local/directadmin ]; then
		echo "`detect_debian_raw_version`-directadmin"
	elif [ -f /etc/openattic/settings.py ]; then
		echo "`detect_debian_raw_version`-openattic"
	else
		echo "`detect_debian_raw_version`"
	fi
}

detect_redhat_version()
{
	if [ -f /etc/oracle-release ]; then
		DATA=`cat /etc/oracle-release`
		case "$DATA" in
			"Oracle Linux Server release 6.2" | "Oracle Linux Server release 6.3" | "Oracle Linux Server release 6.6")
				echo "redhat-oracle6"
				;;
			"Oracle Linux Server release 7.1")
				echo "redhat-oracle7"
				;;
			*)
				echo "redhat-generic-oracle"
				;;
		esac

	elif [ -f /etc/fedora-release ] && [ -f /etc/os-release ]; then
		. /etc/os-release
		if [ "$NAME" = "Fedora" ] && [ "$VERSION_ID" != "" ]; then
			echo "redhat-fedora$VERSION_ID"
		else
			echo "redhat-generic-fedora"
		fi

	elif [ -f /etc/elastix.conf ]; then
		echo "`detect_redhat_raw_version`-elastix"
	elif [ -d /usr/local/cpanel ]; then
		echo "`detect_redhat_raw_version`-cpanel"
	else
		echo "`detect_redhat_raw_version`"
	fi
}

detect_amazon_version()
{
	. /etc/os-release
	echo "amazon-`echo $VERSION_ID |cut -d. -f 1`"
}

detect_suse_version()
{
	if [ -f /etc/os-release ]; then
		. /etc/os-release
		echo "suse-`echo $VERSION_ID |cut -d. -f 1`"
	else
		echo "suse-generic"
	fi
}

detect_slackware_version()
{
	if [ -f /etc/os-release ]; then
		. /etc/os-release
		echo "slackware-`echo $VERSION_ID |cut -d. -f 1`"
	else
		echo "slackware-generic"
	fi
}

detect_netbsd_version()
{
	DATA=`uname -r`
	case "$DATA" in
		"6.1.5")
			echo "netbsd-6"
			;;
		*)
			echo "netbsd-generic"
			;;
	esac
}

detect_openbsd_version()
{
	VER=`uname -r |sed s/\\\.//g`
	echo "openbsd-$VER"
}

detect_freebsd_version()
{
	DATA=`uname -r`
	case "$DATA" in
		"9.3-RELEASE")
			echo "freebsd-9"
			;;
		"10.1-RELEASE")
			echo "freebsd-10"
			;;
		*)
			echo "freebsd-generic"
			;;
	esac
}

detect_qnap_version()
{
	VER=`grep ^Version /etc/default_config/uLinux.conf |head -n1 |awk "{ print \\$3 }" |cut -d. -f1`
	echo "qnap-qts$VER"
}


TYPE="`detect_os_type`"

if [ "$1" = "-type" ]; then
	echo $TYPE
else
	case "$TYPE" in
		debian)
			echo "`detect_debian_version`"
			;;
		redhat)
			echo "`detect_redhat_version`"
			;;
		amazon)
			echo "`detect_amazon_version`"
			;;
		suse)
			echo "`detect_suse_version`"
			;;
		slackware)
			echo "`detect_slackware_version`"
			;;
		netbsd)
			echo "`detect_netbsd_version`"
			;;
		openbsd)
			echo "`detect_openbsd_version`"
			;;
		freebsd)
			echo "`detect_freebsd_version`"
			;;
		qnap)
			echo "`detect_qnap_version`"
			;;
		*)
			exit 1
			;;
	esac
fi

