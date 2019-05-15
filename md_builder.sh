#!/bin/bash
##########################
#
# sourcing configs/${DEVICE}.conf
#
##########################
#
# configure:
#	download:
#		toolchain
#		kernel
#		extras
#	unpack:
#		toolchain
#		kernel
#		extras
#
##########################
#
# clean
# options: kernel media
#	eval ${DEVICE_CODE}_CLEAN
#
##########################
#
# build
# options: kernel media
#	eval ${DEVICE_CODE}_BUILD
#
##########################


TOP_MDB_DIR=`pwd`

device_flag=0
configure_flag=0
clean_flag=0
build_flag=0

while getopts ":d:ibB:cC:gG:" o; do
	case "${o}" in
	d)
		echo "Device: ${OPTARG}"
		device_flag=1
		DEVICE=${OPTARG}
		;;
	i)
		echo "initialize"
		;;
	g)
		echo "configure"
		configure_flag=1
		;;
	G)
		echo "configure ${OPTARG}"
		configure_flag=1
		;;
	c)
		echo "clean"
		clean_flag=1
		;;
	C)
		echo "clean ${OPTARG}"
		clean_flag=1
		;;
	b)
		echo "build"
		build_flag=1
		;;
	B)
		echo "build ${OPTARG}"
		build_flag=1
		;;
	h|*)
		echo "supported devices:"
		for i in `ls configs/*.conf | sort` ; do
			echo -e "\t`basename ${i/.conf/}`"
		done
		exit 0
	esac
done

if [ ! -f "configs/${DEVICE}.conf" ] ; then
	echo "Device ${DEVICE} not found"
	exit 254
fi

source configs/${DEVICE}.conf

eval ${PACKAGE_CODE}_ENVIRONMENT


if [ $configure_flag -eq 1 ] ; then
	eval ${PACKAGE_CODE}_KERNEL_CONFIGURE

	eval ${PACKAGE_CODE}_MEDIA_CONFIGURE
fi

if [ $build_flag -eq 1 ] ; then
	eval ${PACKAGE_CODE}_KERNEL_BUILD

	eval ${PACKAGE_CODE}_MEDIA_BUILD
fi
