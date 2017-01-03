# Ubuntu Desktop ISO Customization

[**Official Site 1**](https://help.ubuntu.com/community/LiveCDCustomization)

[**Official Site 2**](https://help.ubuntu.com/community/LiveCDCustomizationFromScratch)

[**Reference 1**](https://zyisrad.com/linux-livecd-customization)

[**Reference 2**](https://f37ch.com/index.php/2016/05/16/ubuntu-16-04-custom-livecd-scratch/)

### Prerequisite
+ Host Machine: Windows 7 Ultimate 64bit<p>
+ Develop Environment: Ubuntu 16.04.1 Desktop Amd64 running on Vmware 12 Pro<p>
+ ingredient: ubuntu-16.04.1-desktop-amd64.iso<p>

### Goal
  DIY `ubuntu-16.04.1-desktop-amd64.iso`, add some personal stuff into iso<p>

### Procedure

1. Enter into `/home/wisnuc/Documents/` folder

  `cd /home/wisnuc/Documents/`

2. Copy `appifi-bootstrap.js.sha1`, `appifi-bootstrap-update.packed.js`, `node-v6.9.2-linux-x64.tar.xz`, `docker-1.12.4.tgz` & `makeUbuntuWisnucISO.sh (download path: `https://raw.githubusercontent.com/JiangWeiGitHub/UbuntuDesktopISOCustomization/master/shell/makeUbuntuWisnucISO.sh`)` into this folder

3. Run `makeUbuntuWisnucISO.sh` with `root`

  ```
    chmod 755 makeUbuntuWisnucISO.sh
    ./makeUbuntuWisnucISO.sh
  ```
  
4. Using `UltraISO` on Windows 7, burn this ISO to USB stick
