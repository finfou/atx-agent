#!/bin/bash

devices=`adb devices|grep -v "List of devices"|awk '{print $1}'`

for device in $devices
do
	pid=`adb -s ${device} shell "ps | grep atx-agent" | awk '{print $2}'`
	adb -s ${device} shell kill $pid
	adb -s ${device} push ./atx-agent /data/local/tmp/
	adb -s ${device} shell /data/local/tmp/atx-agent -d -t $1
done