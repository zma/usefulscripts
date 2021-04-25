#!/bin/bash

# Download, build and install wine 32-bit on CentOS 8

# For details of this script, please check
# https://www.systutorials.com/how-to-install-wine-32-bit-on-centos-8/

# Authors:
# Mika Knuutila
# Eric Ma (https://www.ericzma.com)

set -o errexit

# Constants
log=`mktemp -t install-wine.XXXXXX.log`
NPROC=$(nproc)
CFLAGS="-g -O2 -std=gnu99"
ver=5.0       # last stable version on 2020-03-19

# Install
if [[ "$1" != "" ]]; then
  ver=$1
fi

vermajor=$(echo ${ver} | cut -d'.' -f1)
verurlstr=$(echo ${ver} | cut -d'.' -f1,2)

if (($vermajor<2)); then
  echo "Only Wine versions >= 2.x are supported."
  exit 3
fi

date > $log
echo "Hello there. Start to download, build and install wine $ver 32-bit version..." | tee -a $log
echo "Logs are in $log" | tee -a $log

echo "Enabling needed repos and update..." | tee -a $log

# Fixes for CentOS 8
dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y 2>&1 >>$log
dnf config-manager --set-enable powertools 2>&1 >>$log
rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro 2>&1 >>$log
dnf install http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm -y 2>&1 >>$log
dnf clean all 2>&1 >>$log
dnf update --best --allowerasing -y 2>&1 >>$log

# echo "Please make sure you have EPEL and Nux Desktop repositories configured. Check https://www.systutorials.com/239893/additional-repositories-centos-linux/ for howto." | tee -a $log

echo "Uninstall old wine if you have installed it..." | tee -a $log

# yum erase wine wine-*
dnf remove wine wine-* -y 2>&1 >>$log

echo "Install wine building tools..." | tee -a $log

dnf install samba-winbind-clients -y 2>&1 >>$log
dnf groupinstall 'Development Tools' -y 2>&1 >> $log
dnf install libjpeg-turbo-devel libtiff-devel freetype-devel -y 2>&1 >> $log
dnf install glibc-devel.{i686,x86_64} libgcc.{i686,x86_64} libX11-devel.{i686,x86_64} freetype-devel.{i686,x86_64} gnutls-devel.{i686,x86_64} libxml2-devel.{i686,x86_64} libjpeg-turbo-devel.{i686,x86_64} libpng-devel.{i686,x86_64} libXrender-devel.{i686,x86_64} alsa-lib-devel.{i686,x86_64} glib2-devel.{i686,x86_64} libSM-devel.{i686,x86_64} -y 2>&1 >> $log

# Fixes for CentOS 8
dnf install http://mirror.centos.org/centos/7/os/x86_64/Packages/prelink-0.5.0-9.el7.x86_64.rpm -y 2>&1 >> $log
dnf install http://mirror.centos.org/centos/7/os/x86_64/Packages/isdn4k-utils-3.2-99.el7.x86_64.rpm -y 2>&1 >> $log
dnf install http://mirror.centos.org/centos/7/os/x86_64/Packages/isdn4k-utils-devel-3.2-99.el7.x86_64.rpm -y 2>&1 >> $log
dnf install glibc-devel libstdc++-devel icoutils openal-soft-devel prelink gstreamer1-plugins-base-devel gstreamer1-devel ImageMagick-devel fontpackages-devel libv4l-devel gsm-devel giflib-devel libXxf86dga-devel mesa-libOSMesa-devel isdn4k-utils-devel libgphoto2-devel fontforge libusb-devel lcms2-devel audiofile-devel -y 2>&1 >> $log

dnf install openldap-devel libxslt-devel libXcursor-devel libXi-devel libXxf86vm-devel libXrandr-devel libXinerama-devel libXcomposite-devel mesa-libGLU-devel ocl-icd opencl-headers libpcap-devel dbus-devel ncurses-devel libsane-hpaio pulseaudio-libs-devel cups-devel libmpg123-devel fontconfig-devel sane-backends-devel.x86_64 -y 2>&1 >> $log

# Fixes for CentOS 8
dnf install http://mirror.centos.org/centos/7/os/x86_64/Packages/isdn4k-utils-3.2-99.el7.i686.rpm -y 2>&1 >> $log
dnf install http://mirror.centos.org/centos/7/os/x86_64/Packages/isdn4k-utils-devel-3.2-99.el7.i686.rpm -y 2>&1 >> $log
dnf install http://mirror.centos.org/centos/7/os/x86_64/Packages/audiofile-0.3.6-4.el7.i686.rpm -y 2>&1 >> $log
dnf install http://mirror.centos.org/centos/7/os/x86_64/Packages/audiofile-devel-0.3.6-4.el7.i686.rpm -y 2>&1 >> $log
dnf install http://mirror.centos.org/centos/7/os/x86_64/Packages/qt-4.8.7-8.el7.i686.rpm -y 2>&1 >> $log
dnf install http://mirror.centos.org/centos/7/os/x86_64/Packages/libmng-1.0.10-14.el7.i686.rpm -y 2>&1 >> $log
dnf install http://mirror.centos.org/centos/7/os/x86_64/Packages/qt-x11-4.8.7-8.el7.i686.rpm -y 2>&1 >> $log
dnf install http://mirror.centos.org/centos/7/os/x86_64/Packages/qt-devel-4.8.7-8.el7.i686.rpm -y 2>&1 >> $log
dnf install http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/vulkan-loader-devel-1.2.148.0-1.el8.i686.rpm -y 2>&1 >> $log
dnf install http://mirror.centos.org/centos/8/PowerTools/x86_64/os/Packages/mpg123-devel-1.25.10-2.el8.i686.rpm -y 2>&1 >> $log
dnf install https://pkgs.dyn.su/el8/extras/x86_64/libvkd3d-1.1-3.el8.i686.rpm -y 2>&1 >> $log
dnf install https://pkgs.dyn.su/el8/extras/x86_64/libvkd3d-devel-1.1-3.el8.i686.rpm -y 2>&1 >> $log
dnf install https://pkgs.dyn.su/el8/multimedia/x86_64/libFAudio-20.07-1.el8.8_2.i686.rpm -y 2>&1 >> $log
dnf install https://pkgs.dyn.su/el8/multimedia/x86_64/libFAudio-devel-20.07-1.el8.8_2.i686.rpm -y 2>&1 >> $log
dnf install https://pkgs.dyn.su/el8/multimedia/x86_64/libFAudio-20.07-1.el8.8_2.x86_64.rpm -y 2>&1 >> $log
dnf install https://pkgs.dyn.su/el8/multimedia/x86_64/libFAudio-devel-20.07-1.el8.8_2.x86_64.rpm -y 2>&1 >> $log

dnf install glibc-devel.i686 dbus-devel.i686 freetype-devel.i686 pulseaudio-libs-devel.i686 libX11-devel.i686 mesa-libGLU-devel.i686 libICE-devel.i686 libXext-devel.i686 libXcursor-devel.i686 libXi-devel.i686 libXxf86vm-devel.i686 libXrender-devel.i686 libXinerama-devel.i686 libXcomposite-devel.i686 libXrandr-devel.i686 mesa-libGL-devel.i686 mesa-libOSMesa-devel.i686 libxml2-devel.i686 zlib-devel.i686 gnutls-devel.i686 ncurses-devel.i686 sane-backends-devel.i686 libv4l-devel.i686 libgphoto2-devel.i686 libexif-devel.i686 lcms2-devel.i686 gettext-devel.i686 isdn4k-utils-devel.i686 cups-devel.i686 fontconfig-devel.i686 gsm-devel.i686 libjpeg-turbo-devel.i686 libtiff-devel.i686 unixODBC.i686 openldap-devel.i686 alsa-lib-devel.i686 audiofile-devel.i686 freeglut-devel.i686 giflib-devel.i686 gstreamer1-devel.i686 gstreamer1-plugins-base-devel.i686 libXmu-devel.i686 libXxf86dga-devel.i686 libieee1284-devel.i686 libpng-devel.i686 librsvg2-devel.i686 libstdc++-devel.i686 libusb-devel.i686 unixODBC-devel.i686 qt-devel.i686 libpcap-devel.i686 -y 2>&1 >> $log
# Conflicting: pkgconfig.i686, libxslt-devel.i686, qt-devel.i686 and qt-x11.i686
dnf clean all 2>&1 >>$log
dnf update --best --allowerasing -y 2>&1 >>$log
dnf builddep wine -y 2>&1 >>$log
dnf update -y 2>&1 >>$log

# for wine 2 and up
# Thanks to gretzware https://www.systutorials.com/install-32-bit-wine-1-8-centos-7/#comment-157977
dnf install gstreamer1-plugins-base-devel.{x86_64,i686} gstreamer1-devel.{x86_64,i686} systemd-devel.{x86_64,i686} -y 2>&1 >> $log

# Thanks to gretzware https://www.systutorials.com/install-32-bit-wine-1-8-centos-7/#comment-158134
dnf install libXfixes-devel.{x86_64,i686}  -y 2>&1 >> $log

echo "Download and unpack the wine source package..." 2>&1 | tee -a $log

cd /usr/src 2>&1 >> $log
wget http://dl.winehq.org/wine/source/${verurlstr}/wine-${ver}.tar.xz -O wine-${ver}.tar.xz 2>&1 >> $log
tar xf wine-${ver}.tar.xz 2>&1 >> $log

echo "Build wine..." 2>&1 | tee -a $log
cd wine-${ver}/ 2>&1 >> $log
mkdir -p wine32 wine64 2>&1 >> $log

echo "   build wine64..." 2>&1 | tee -a $log
cd wine64 2>&1 >> $log
../configure --enable-win64 CFLAGS="${CFLAGS}" 2>&1 >> $log
make -j $NPROC 2>&1 >> $log

echo "   build wine32..." 2>&1 | tee -a $log
cd ../wine32 2>&1 >> $log
PKG_CONFIG_PATH=/usr/lib/pkgconfig ../configure --with-wine64=../wine64 CFLAGS="${CFLAGS}" 2>&1 >> $log
make -j $NPROC 2>&1 >> $log

echo "Install wine..." 2>&1 | tee -a $log
echo "   install wine32..." 2>&1 | tee -a $log
make install 2>&1 >> $log

echo "   install wine64..." 2>&1 | tee -a $log
cd ../wine64 2>&1 >> $log
make install 2>&1 >> $log

echo "Congratulation! All are done. Enjoy!" 2>&1 | tee -a $log
# rm -f $log

# # Uninstall
# cd /usr/src/wine-${ver}/wine32
# make uninstall
# cd /usr/src/wine-${ver}/wine64
# make uninstall

