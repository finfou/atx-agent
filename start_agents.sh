#!/bin/bash
set -x

devices=`adb devices|grep -v "List of devices"|awk '{print $1}'`

for device in $devices
do
	pid=`adb -s ${device} shell "ps | grep atx-agent" | awk '{print $2}'`
	[ -z "${pid}" ] || adb -s ${device} shell kill $pid
	adb -s ${device} shell touch /data/local/tmp/pertest
	adb -s ${device} shell chmod +x /data/local/tmp/pertest
	pertest=`adb -s ${device} shell stat -c%A /data/local/tmp/pertest`
	rundir='/data/local/tmp' 
	[ -z "${pertest##*x*}" ] || rundir='/data/data/com.android.shell'
	adb -s ${device} push ./atx-agent ${rundir}
	adb -s ${device} shell $rundir/atx-agent -d -t $1
done