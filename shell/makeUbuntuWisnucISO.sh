#!/bin/bash

set -e

DASH="------------------------------------------------------------"

banner()
{
	echo ""
	echo $DASH
	echo "$1"
	echo $DASH
	echo ""
}

banner "Run `makeUbuntuWisnucISO.sh`"

sudo su
apt update
apt install squashfs-tools genisoimage

banner "Create tmp folder"
mkdir /var/tmp/livecd/
cd /var/tmp/livecd/
mkdir mnt/
mkdir extract-cd/

banner "Mount ISO"
### mount iso ###
mount -o loop,ro /home/wisnuc/Documents/ubuntu-16.04.1-desktop-amd64.iso mnt/

banner "Extract `rootfs`"
### extract rootfs ###
rsync --exclude=/casper/filesystem.squashfs -a mnt/ extract-cd
unsquashfs mnt/casper/filesystem.squashfs

mv squashfs-root edit
umount mnt

banner "Modify `rootfs`"
### modify rootfs ###
cp /etc/resolv.conf edit/etc/
cp /etc/hosts edit/etc 
cp /home/wisnuc/Documents/appifi-bootstrap* /var/tmp/livecd/edit/tmp/
cp /home/wisnuc/Documents/node-v6.9.2-linux-x64.tar.xz /var/tmp/livecd/edit/tmp/
cp /home/wisnuc/Documents/docker-1.12.4.tgz /var/tmp/livecd/edit/tmp/
mount --bind /dev edit/dev

#
# enter chroot
#
banner "Run chroot"
wget https://raw.githubusercontent.com/JiangWeiGitHub/UbuntuDesktopISOCustomization/master/shell/chroot.sh
chmod 755 chroot.sh
chroot edit /bin/bash -c "/var/tmp/livecd/chroot.sh"

#
# quit from chroot
#
banner "Return from chroot"
umount edit/dev || umount -lf edit/dev

banner "Create a new `rootfs`"
### create a new rootfs ###
chmod +w extract-cd/casper/filesystem.manifest
chroot edit dpkg-query -W --showformat='${Package} ${Version}\n' > extract-cd/casper/filesystem.manifest

cp extract-cd/casper/filesystem.manifest extract-cd/casper/filesystem.manifest-desktop
sed -i '/ubiquity/d' extract-cd/casper/filesystem.manifest-desktop
sed -i '/casper/d' extract-cd/casper/filesystem.manifest-desktop

mksquashfs edit extract-cd/casper/filesystem.squashfs

printf $(du -sx --block-size=1 edit | cut -f1) > extract-cd/casper/filesystem.size
rm extract-cd/md5sum.txt
cd extract-cd
find -type f -print0 | xargs -0 md5sum | grep -v isolinux/boot.cat | tee md5sum.txt

banner "Create a new ISO"
mkisofs -D -r -V "$IMAGE_NAME" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../CustomDistro.iso .

### exit sudo ###
exit
