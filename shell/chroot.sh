#!/bin/bash

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
