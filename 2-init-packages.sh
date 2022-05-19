#!/bin/bash

wget_cmd() {
	wget --no-check-certificate --timeout 15 -4 --tries=5 $* || exit 1
}

mkdir -p downloads && cd downloads
{
	if [ ! -f 1.1-17.10.30-release.tar.gz ]
	then
		wget_cmd http://typecho.org/downloads/1.1-17.10.30-release.tar.gz
	fi
} &
{
	if [ ! -f ttyd.armhf ]
	then
		wget_cmd https://git.histb.com/tsl0922/ttyd/releases/download/1.6.3/ttyd.armhf
	fi
} &
{
	if [ ! -f AriaNg-1.2.3.zip ]
	then
		wget_cmd https://git.histb.com/mayswind/AriaNg/releases/download/1.2.3/AriaNg-1.2.3.zip
	fi
} &
wait
cd -

# ttyd
cp -a pre_files/ttyd.service rootfs/etc/systemd/system
chmod 644 rootfs/etc/systemd/system/ttyd.service
cp -a downloads/ttyd.armhf rootfs/usr/bin/ttyd
chmod +x rootfs/usr/bin/ttyd

mkdir -p rootfs/etc/network/interfaces.d
touch -f rootfs/etc/network/interfaces.d/eth0
cat <<EOT >> rootfs/etc/network/interfaces.d/eth0
auto eth0
iface eth0 inet dhcp
EOT

# choose mv100 or mv200
echo "
1. mv100
2. mv200
3. mv300
"
while :; do
read -p "你想要定制哪个版本？ " CHOOSE
case $CHOOSE in
	1)
		bootargs="mv100"
	break
	;;
	2)
		bootargs="mv200"
	break
	;;
	3)
		bootargs="mv300"
	break
	;;
esac
done
cp -a pre_files/bootargs4-$bootargs.bin rootfs/usr/bin/bootargs4.bin
cp -a pre_files/boot4.sh rootfs/usr/bin/recoverbackup
chmod 777 rootfs/usr/bin/recoverbackup
echo "hi3798$bootargs" > rootfs/etc/hostname


# others
chmod 755 -R pre_files/sbin
cp -a pre_files/sbin/* rootfs/sbin
cp -a pre_files/profile.d/99-helloworld.sh rootfs/etc/profile.d
chmod 755 -R rootfs/etc/profile.d

echo "$(date +%Y%m%d)" > rootfs/etc/nasversion


# end
cat << EOF | chroot rootfs
systemctl enable ttyd
EOF

