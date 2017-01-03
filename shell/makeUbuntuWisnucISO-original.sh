#!/bin/bash

### before run this scripte ###

# sudo su
# apt update
# copy `ubuntu-16.04.1-desktop-amd64.iso & node-v6.9.2-linux-x64.tar.xz & docker-1.12.4.tgz & appifi-bootstrap-update.packed.js & appifi-bootstrap.js.sha1` to `/home/wisnuc/Documents/`

###############################

sudo su
apt install squashfs-tools genisoimage

mkdir /var/tmp/livecd/
cd /var/tmp/livecd/
mkdir mnt/
mkdir extract-cd/

### mount iso ###
mount -o loop,ro /home/wisnuc/Documents/ubuntu-16.04.1-desktop-amd64.iso mnt/

### extract rootfs ###
rsync --exclude=/casper/filesystem.squashfs -a mnt/ extract-cd
unsquashfs mnt/casper/filesystem.squashfs

mv squashfs-root edit
umount mnt

### modify rootfs ###
cp /etc/resolv.conf edit/etc/
cp /etc/hosts edit/etc 
cp /home/wisnuc/Documents/appifi-bootstrap* /var/tmp/livecd/edit/tmp/
cp /home/wisnuc/Documents/node-v6.9.2-linux-x64.tar.xz /var/tmp/livecd/edit/tmp/
cp /home/wisnuc/Documents/docker-1.12.4.tgz /var/tmp/livecd/edit/tmp/
mount --bind /dev edit/dev

chroot edit 
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts

export HOME=/root
export LC_ALL=C
# export XAUTHORITY=/.Xauthority

dbus-uuidgen > /var/lib/dbus/machine-id
dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl

### run my script ###

cd tmp
wget https://raw.githubusercontent.com/JiangWeiGitHub/appifi-system/master/amd64/pc/ubuntu-16-04-1-amd64/install-appifi.sh
chmod 755 install-appifi.sh
./install-appifi.sh

#####################

### clean ###
rm -rf /tmp/* ~/.bash_history
# rm /.Xauthority 
rm /var/lib/dbus/machine-id
rm /sbin/initctl
dpkg-divert --rename --remove /sbin/initctl

umount /proc || umount -lf /proc
umount /sys
umount /dev/pts

### exit chroot ###
exit

umount edit/dev || umount -lf edit/dev

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
mkisofs -D -r -V "$IMAGE_NAME" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../CustomDistro.iso .

### exit sudo ###
exit
