# Ubuntu Desktop ISO Customization

[**Reference**](https://pgtux.wordpress.com/2014/10/30/penguintux-iso-with-ubuntu-customization-kit-uck-gui/)

[**Question**](https://answers.launchpad.net/uck/+question/293948)

### Develop Environment
+ Host Machine: Windows 7 Ultimate 64bit
+ Develop Environment: Ubuntu 16.04.1 Desktop Amd64 running on Vmware 12 Pro
+ ingredient: ubuntu-16.04.1-desktop-amd64.iso file

### Goal
+ DIY `ubuntu-16.04.1-desktop-amd64.iso`, add some personal stuff into iso

### Procedure
1. update & upgrade apt source list<p>
```
  sudo apt update
  sudo apt upgrade
```
2. install `Ubuntu Customization Kit` & dependency packages<p>
`sudo apt install uck syslinux-utils squashfs-tools dctrl-tools`

3. modify some configure files
  + `/usr/lib/uck/customization-profiles/localized_cd/customize_iso`
  + `/usr/lib/uck/customization-profiles/localized_cd/customize`

```
  ##### /usr/lib/uck/customization-profiles/localized_cd/customize_iso #####

  # Create a temporary directory to assemble the gfxboot stuff in
  BUILD_DIR=`mktemp -d`
  if [ -d $REMASTER_HOME/gfxboot-theme-ubuntu ]
  then
    cp -r $REMASTER_HOME/gfxboot-theme-ubuntu "$BUILD_DIR" ||
      failure "Cannot copy gfxboot-theme-ubuntu to $BUILD_DIR"
    pushd "$BUILD_DIR" >/dev/null ||
      failure "Cannot change directory to $BUILD_DIR"
  else
    pushd "$BUILD_DIR" >/dev/null ||
      failure "Cannot change directory to $BUILD_DIR"
    DISTRO_CODENAME=`cd "$ISO_REMASTER_DIR"/dists && find . -maxdepth 1 -type d | grep '/' | cut -d '/' -f2` ||
      failure "Unable to identify Ubuntu distro codename"
    APT_SOURCES_TMP_DIR=`mktemp -d`
    wget -c http://archive.ubuntu.com/ubuntu/ubuntu/ubuntu/dists/$DISTRO_CODENAME/main/source/Sources.gz -O "$APT_SOURCES_TMP_DIR"/Sources.gz
    GFXBOOT_THEME_UBUNTU_SOURCE_PACKAGE=http://archive.ubuntu.com/ubuntu/ubuntu/ubuntu/pool/main/g/gfxboot-theme-ubuntu/$(zgrep gz "$APT_SOURCES_TMP_DIR"/Sources.gz | grep gfxboot-theme-ubuntu | sed -n 1p | awk '{ print $3 }')

    ########################################################################
    ##### Change Download Path #####
    ########################################################################
    # wget $GFXBOOT_THEME_UBUNTU_SOURCE_PACKAGE ||
    wget http://archive.ubuntu.com/ubuntu/pool/main/g/gfxboot-theme-ubuntu/gfxboot-theme-ubuntu_0.20.1.tar.xz ||
    ########################################################################
      failure "Unable to download gfxboot-theme-ubuntu source package from $GFXBOOT_THEME_UBUNTU_SOURCE_PACKAGE"

    ########################################################################
    ##### Change file's type #####
    ########################################################################
    # tar xfz *.tar.gz ||
    tar xfJ *.tar.xz ||
    ########################################################################
      failure "Unable to extract gfxboot-theme-ubuntu source package"
  fi
```

```
  ##### /usr/lib/uck/customization-profiles/localized_cd/customize #####

  function run_console()
  {
    echo "Starting console application..."

    CONSOLE_APP=`which konsole`
    CONSOLE_APP_OPTIONS=(--caption "UCK customization console" -e /bin/bash)

    ########################################################################
    ##### Commented Out #####
    ########################################################################
    # if [ "$CONSOLE_APP" = "" ]; then
    #   CONSOLE_APP=`which gnome-terminal`
    #   CONSOLE_APP_OPTIONS=(-t "UCK customization console" -e /bin/bash)
    # fi
    ########################################################################

    if [ "$CONSOLE_APP" = "" ]; then
      CONSOLE_APP=`which xfce4-terminal`
      CONSOLE_APP_OPTIONS=(-T "UCK customization console" -e /bin/bash)
    fi
    if [ "$CONSOLE_APP" = "" ]; then
      CONSOLE_APP=`which lxterminal`
      CONSOLE_APP_OPTIONS=(-t "UCK customization console" -e /bin/bash)
    fi
    if [ "$CONSOLE_APP" = "" ]; then
      CONSOLE_APP=`which xterm`
      CONSOLE_APP_OPTIONS=(-title "UCK customization console" -e /bin/bash)
    fi

    if [ "$CONSOLE_APP" = "" ]; then
      dialog_msgbox "Failure" "Unable to find any console application"
    else
      eval `dbus-launch --sh-syntax --exit-with-session 2>/dev/null`
      $CONSOLE_APP "${CONSOLE_APP_OPTIONS[@]}"
      RESULT=$?
    fi
  }
```
