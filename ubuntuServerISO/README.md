# Ubuntu Desktop ISO Customization

[**Official Site 1**](https://help.ubuntu.com/community/LiveCDCustomization)

[**Official Site 2**](https://help.ubuntu.com/community/LiveCDCustomizationFromScratch)

[**Reference 1**](https://zyisrad.com/linux-livecd-customization)

[**Reference 2**](https://f37ch.com/index.php/2016/05/16/ubuntu-16-04-custom-livecd-scratch/)

### Prerequisite
+ Host Machine: Windows 7 Ultimate 64bit<p>
+ Develop Environment: Ubuntu 16.04.1 Desktop Amd64 running on Vmware 12 Pro<p>
+ Ingredient: ubuntu-16.04.1-desktop-amd64.iso<p>
+ Existed a user named `wisnuc`, and there is a folder named `/home/wisnuc/Documents/`<p>

### Goal
  DIY `ubuntu-16.04.1-desktop-amd64.iso`, add some personal stuff into iso<p>

### Notice
  + `chroot.sh` will be downloaded automatically by `makeUbuntuWisnucISO.sh`
  + `filesystem.manifest-remove` will be downloaded automatically by `makeUbuntuWisnucISO.sh`, I removed `btrfs-tool` & `samba` fields
  + `makeUbuntuWisnucISO-original.sh` does not has been used in this procedure

### Procedure

1. Enter into `/home/wisnuc/Documents/` folder

  `cd /home/wisnuc/Documents/`

2. Copy some files into this folder<p>
  - `appifi-bootstrap.js.sha1` [*download path*](https://raw.githubusercontent.com/wisnuc/appifi-bootstrap/release/appifi-bootstrap.js.sha1)<p>
  - `appifi-bootstrap-update.packed.js` [*download path*](https://raw.githubusercontent.com/wisnuc/appifi-bootstrap-update/release/appifi-bootstrap-update.packed.js)<p>
  - `node-v6.9.2-linux-x64.tar.xz` [*download path*](https://nodejs.org/dist/v6.9.2/node-v6.9.2-linux-x64.tar.xz)<p>
  - `docker-1.12.4.tgz` [*download path*](https://get.docker.com/builds/Linux/x86_64/docker-1.12.4.tgz)<p>
  - `makeUbuntuWisnucISO.sh` [*download path*](https://raw.githubusercontent.com/JiangWeiGitHub/UbuntuDesktopISOCustomization/master/shell/makeUbuntuWisnucISO.sh)<p>

3. Run `makeUbuntuWisnucISO.sh` with `root`

  ```
    chmod 755 makeUbuntuWisnucISO.sh
    ./makeUbuntuWisnucISO.sh
  ```
  
4. ISO file will be existed under `/home/wisnuc/Documents/`, using `UltraISO` on Windows 7, burn this ISO to USB stick
