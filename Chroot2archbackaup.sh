#!/bin/sh
#	Name: chroot2archbackup.sh
#
#       Description: Chroot to Arch Backup located on /mnt/chroot/
#
#       Change:
#	Owner : jalmeida (juanma.almeida -AT- gmail.com)
#
mount -t auto /dev/sda5 /mnt/chroot/
mount -o bind /dev /mnt/chroot/dev
mount -o bind /proc /mnt/chroot/proc
mount -o bind /sys /mnt/chroot/sys
mount -t auto /dev/VolGroup00/lvolvar /mnt/chroot/var
mount -t auto /dev/VolGroup00/lvolhome /mnt/chroot/home
cp -L /etc/resolv.conf /mnt/chroot/etc/resolv.conf
chroot /mnt/chroot /bin/bash
source /etc/profile

