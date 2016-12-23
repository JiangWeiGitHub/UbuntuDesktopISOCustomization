#!/bin/bash

sudo su
apt-get install squashfs-tools genisoimage
mkdir /var/tmp/livecd/
cd /var/tmp/livecd/ 
mkdir mnt/
mkdir extract-cd/
mount -o loop,ro /path/to/LinuxDistro.iso mnt/
rsync --exclude=/casper/filesystem.squashfs -a mnt/ extract-cd
unsquashfs mnt/casper/filesystem.squashfs
mv squashfs-root edit 
umount mnt
cp /etc/resolv.conf edit/etc/
cp /etc/hosts edit/etc 
mount --bind /dev edit/dev
chroot edit 
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts
export HOME=/root
export LC_ALL=C
export XAUTHORITY=/.Xauthority
dbus-uuidgen > /var/lib/dbus/machine-id
dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl

run myscript

rm -rf /tmp/* ~/.bash_history
rm /.Xauthority 
rm /var/lib/dbus/machine-id
rm /sbin/initctl
dpkg-divert --rename --remove /sbin/initctl
umount /proc || umount -lf /proc
umount /sys
umount /dev/pts
exit 
umount edit/dev || umount -lf edit/dev

chmod +w extract-cd/casper/filesystem.manifest
sudo chroot edit dpkg-query -W --showformat='${Package} ${Version}\n' > extract-cd/casper/filesystem.manifest 
cp extract-cd/casper/filesystem.manifest extract-cd/casper/filesystem.manifest-desktop
sed -i '/ubiquity/d' extract-cd/casper/filesystem.manifest-desktop
sed -i '/casper/d' extract-cd/casper/filesystem.manifest-desktop
rm extract-cd/casper/filesystem.squashfs
mksquashfs edit extract-cd/casper/filesystem.squashfs
printf $(sudo du -sx --block-size=1 edit | cut -f1) > extract-cd/casper/filesystem.size
rm extract-cd/md5sum.txt
cd extract-cd
find -type f -print0 | sudo xargs -0 md5sum | grep -v isolinux/boot.cat | sudo tee md5sum.txt
mkisofs -D -r -V "$IMAGE_NAME" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../CustomDistro.iso .
