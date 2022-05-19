#!/bin/bash

### BEGIN INIT INFO
# Provides:          www.ecoo.top
# Required-Start:
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: self define auto start
# Description:       self define auto start
### END INIT INFO

if [ ! -f /etc/first_init ]
then
	resize2fs /dev/mmcblk0p6 &
fi
if [ ! -f /etc/first_init ]
then
	echo "resize2fs /dev/mmcblk0p6" > /etc/first_init
fi
echo "/sbin/automount" > /sys/kernel/uevent_helper
/sbin/automount -a &
echo 42 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio42/direction
/sbin/net_status &
