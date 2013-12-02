#!/bin/sh
##								**
##	Usage : Backup_arch-root.sh $destination_folder		**
##
PWD=`pwd`
FSTAB=$PWD/fstab
LOGFILE=$PWD/backup.log
PARTITION=/dev/sda5
DEST=/mnt/lvm-root/
DATE=$(date -d yesterday +"%Y%m%d")

if_error() {
        if [ ! $? -eq 0 ] ; then
                log "Error $1 ..."
                exit
        fi
}

umounts() {
	umount /boot
	umount /mnt/lvm-root/
}

rsync_root() {

	START=$(date +%s)
	mount -t auto $PARTITION $DEST
	if_error "mounting ${PARTITION} on ${DEST} ..."

	rsync -aAXv /* $DEST --exclude={/dev/*,/proc/*,/sys/*,/var/*,/home/*,/tmp/*,/run/*,/mnt/*,/Site/*,/media/*,/lost+found,/home/*/.gvfs,/var/lib/pacman/sync/*}
	if_error "when rsync to ${DEST} ..."
	FINISH=$(date +%s)
	log "total time: $(( ($FINISH-$START) / 60 )) minutes, $(( ($FINISH-$START) % 60 )) seconds"

	cp $FSTAB $DEST/etc/fstab > /dev/null 2>&1
	if_error "copying ${FSTAB} to ${DEST} ..."

	umount $DEST
	if_error "mounting ${DEST} ..."

}

rollback_kernel() {

        log 'Mount /boot'
        mount /boot > /dev/null 2>&1
	if_error "mounting /boot ..."

	log 'Backup old kernel for grub'
        cp /boot/initramfs-linux-fallback.img /boot/initramfs-linux-fallback-bak.img > /dev/null 2>&1
        if_error "backup initramfs-linux-fallback.img ..."


        cp /boot/initramfs-linux.img /boot/initramfs-linux-bak.img > /dev/null 2>&1
        if_error "backup initramfs-linux.img ..."

        cp /boot/vmlinuz-linux /boot/vmlinuz-linux-bak > /dev/null 2>&1
        if_error "backup vmlinuz-linux ..."

        log 'Umount /boot'
	umount /boot  > /dev/null 2>&1
        if_error "Umounting /boot ..."

}

upgrade_pacman() {

        #Actualizar lista de paquetes.
        pacman -Syy
	if_error "upgrading pacman list ..."

}

#Aqui Actualizamos el systema


upgrade_system(){

	# Actualizar el sistema
	pacman -Su
	if_error "upgrading SYSTEM ..."

}


create_backup_kernel() {

	log 'Unmount /boot'
	umount /boot > /dev/null 2>&1
        if_error "Umounting /boot ..."

	log 'Making Directory'
	mkdir /root/kernel/$DATE > /dev/null 2>&1
	if_error "Making dir for backup ..."

	cd /root/kernel/$DATE > /dev/null 2>&1
	log 'Store backup files'
	cp /boot/initramfs-linux-fallback.img /root/kernel/$DATE/  > /dev/null 2>&1
	if_error "backup initramfs-linux-fallback.img ..."

	cp /boot/initramfs-linux.img /root/kernel/$DATE/  > /dev/null 2>&1
	if_error "copying initramfs-linux.img"

	cp /boot/vmlinuz-linux /root/kernel/$DATE/  > /dev/null 2>&1
	if_error "copying vmlinuz-linux"

	echo 'Mount Boot'
	mount /boot  > /dev/null 2>&1
        if_error "mounting boot"

	echo 'Copy new kernel to /boot'
	cp /root/kernel/$DATE/initramfs-linux-fallback.img /boot/ > /dev/null 2>&1
        if_error "copying /initramfs-linux-fallback.img to /boot"

	cp /root/kernel/$DATE/initramfs-linux.img /boot/ > /dev/null 2>&1
        if_error "copying initramfs-linux.img to /boot"

	cp /root/kernel/$DATE/vmlinuz-linux /boot/ > /dev/null 2>&1
        if_error "copying vmlinuz-linux to /boot/"

}

log() {

    # added time infomation for later calculations or future script expansion
    echo -e "[`date | awk '{print $4}'`] $@"
}

log "**********************"
log "Starting backup Script"
log "**********************"
log "**********************"
log "Umount all"
umounts
log "Starting Rsync"
rsync_root
log "Starting Rollback kernel copy"
rollback_kernel
log "Upgrade PACMAN"
upgrade_pacman
log "END-END-END"
log "Upgrading SYSTEM"
upgrade_system
log "Upgrading kernel on /boot"
#create_backup_kernel
log "END-END-END"
