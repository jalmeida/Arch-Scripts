
#!/bin/sh
#	Usage : Backup_arch-root.sh $destination_folder
#
#	Change:
#		$PARTITION = "Source Folder from root"
#		$DEST = "Destination Folder"
#
#
PARTITION=/dev/mapper/VolGroup00-lvolroot
DEST=/mnt/lvm-root/
mount -t auto $PARTITION $DEST
START=$(date +%s)
rsync -aAXv /* $DEST --exclude={/dev/*,/proc/*,/sys/*,/var/*,/home/*,/tmp/*,/run/*,/mnt/*,/Site/*,/media/*,/lost+found,/home/*/.gvfs,/var/lib/pacman/sync/*}
FINISH=$(date +%s)
echo "total time: $(( ($FINISH-$START) / 60 )) minutes, $(( ($FINISH-$START) % 60 )) seconds"
