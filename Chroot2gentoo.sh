#!/bin/sh
#       Name: chroot2gentoo.sh
#
#       Description: Chroot to Gentoo Partition located on /mnt/gentoo/
#
#       Change:
#       Owner : jalmeida (juanma.almeida -AT- gmail.com)
#

cd /mnt/gentoo/
#mount -t auto /dev/sda5 /mnt/chroot/
mount -o bind /dev /mnt/gentoo/dev
mount -o bind /proc /mnt/gentoo/proc
mount -o bind /sys /mnt/gentoo/sys
mount -t devpts pts dev/pts/
cp -L /etc/resolv.conf /mnt/gentoo/etc/resolv.conf
chroot /mnt/gentoo
source /etc/profile

