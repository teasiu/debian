#!/bin/bash

apt-get install binfmt-support debootstrap -y
debootstrap --arch=armhf --variant=minbase  --foreign --include=locales,util-linux,net-tools,apt-utils,ifupdown,systemd-sysv,iproute2,curl,wget,expect,ca-certificates,openssh-server,isc-dhcp-client,vim,bzip2,cpio,usbutils,netbase,wireless-tools,iw,iputils-ping,bash-completion,sudo,cron,ethtool,zip,htop,rsyslog,resolvconf,ntpdate,linuxlogo,ntp,jq,dialog,smartmontools,dnsutils bullseye rootfs http://mirrors.ustc.edu.cn/debian/

mkdir -p downloads

cp -a pre_files/system-init.sh rootfs/etc/init.d
chmod +x rootfs/etc/init.d/system-init.sh
echo "nameserver 223.5.5.5" > rootfs/etc/resolv.conf
echo "127.0.0.1 localhost" > rootfs/etc/hosts
cd rootfs
LC_ALL=C LANGUAGE=C LANG=C chroot . /debootstrap/debootstrap --second-stage
LC_ALL=C LANGUAGE=C LANG=C chroot . dpkg --configure -a
cat << EOF | LC_ALL=C LANGUAGE=C LANG=C chroot . /bin/bash
mknod /dev/console c 5 1
mknod /dev/ttyAMA0 c 204 64
mknod /dev/ttyAMA1 c 204 65
mknod /dev/ttyS000 c 204 64
mknod /dev/null    c 1   3
mknod /dev/urandom   c 1   9
mknod /dev/zero    c 1   5
mknod /dev/random    c 1   8
mknod /dev/tty    c 5   0
apt update
sed -i -e 's/#PasswordAuthentication/PasswordAuthentication/g' /etc/ssh/sshd_config
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "Asia/Shanghai" > /etc/timezone
cp -a /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
zh_CN.GB2312 GB2312
zh_CN.GBK GBK" > /etc/locale.gen
locale-gen
echo "LANG=zh_CN.UTF-8" > /etc/locale.conf
echo 'LC_CTYPE="zh_CN.UTF-8"
LC_ALL="zh_CN.UTF-8"
LANG="zh_CN.UTF-8"
' > /etc/default/locale
update-rc.d system-init.sh defaults 99
echo -e "1234\n1234\n" | passwd root
visudo -c
apt-get autoremove --purge -y
apt-get autoclean -y
apt-get clean -y
apt autoremove -y
apt clean -y
EOF

