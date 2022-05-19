#!/bin/bash

OUTPUT="debian-armhf-$(date +%Y%m%d).img"
TMPFS="tmp"
echo "System.img will output into: $(pwd)/$OUTPUT"

[ -f "$OUTPUT" ] && rm -f "$OUTPUT"
dd if=/dev/zero of=$OUTPUT count=1000 obs=1 seek=1280M
# dd if=/dev/zero of=$OUTPUT bs=1M count=1280
mkfs.ext4 $OUTPUT
umount $TMPFS 2> /dev/null ; rm -rf "$TMPFS" ; mkdir -p $TMPFS ; sleep 1
mount $OUTPUT $TMPFS
echo "Writing system files to $TMPFS ..."
cp -a rootfs/* $TMPFS
sync
umount $TMPFS 2> /dev/null ; rm -rf "$TMPFS"
e2fsck -p -f $OUTPUT
resize2fs -M $OUTPUT

echo "Please check bytes of the output file below 716800000 or not"
echo "Want test? dd if=$OUTPUT of=/dev/mmcblk0p5"
echo "Then recoverbackup"
