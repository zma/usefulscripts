#!/bin/bash

# Download, build and install wine 32-bit on CentOS 7

# For details of this script, please check
# https://www.systutorials.com/install-32-bit-wine-1-8-centos-7/

# Author: Eric Ma (https://www.ericzma.com)

set -o errexit

# Constants
log=`mktemp -t install-wine.XXXXXX.log`
NPROC=$(nproc)
CFLAGS="-g -O2 -std=gnu99"
wine2up="2 3 4" # wine 2 and up
ver=4.0.1       # last stable version on 2019-05-15

# Install
if [[ "$1" != "" ]]; then
  ver=$1
fi

vermajor=$(echo ${ver} | cut -d'.' -f1)
verurlstr=$(echo ${ver} | cut -d'.' -f1,2)

date > $log
echo "Hello there. Start to download, build and install wine $ver 32-bit version..." | tee -a $log
echo "Logs are in $log" | tee -a $log

echo "Please make sure you have EPEL and Nux Desktop repositories configured. Check https://www.systutorials.com/additional-repositories-centos-linux/ for howto." | tee -a $log
echo "Uninstall old wine64 if you have installed it. Please select yes..." | tee -a $log

yum erase wine wine-*

echo "Install wine building tools..." | tee -a $log

yum install samba-winbind-clients -y 2>&1 >>$log
yum groupinstall 'Development Tools' -y 2>&1 >> $log
yum install libjpeg-turbo-devel libtiff-devel freetype-devel -y 2>&1 >> $log
yum install glibc-devel.{i686,x86_64} libgcc.{i686,x86_64} libX11-devel.{i686,x86_64} freetype-devel.{i686,x86_64} gnutls-devel.{i686,x86_64} libxml2-devel.{i686,x86_64} libjpeg-turbo-devel.{i686,x86_64} libpng-devel.{i686,x86_64} libXrender-devel.{i686,x86_64} alsa-lib-devel.{i686,x86_64} glib2-devel.{i686,x86_64} libSM-devel.{i686,x86_64} -y 2>&1 >> $log

# Thanks to David https://www.systutorials.com/install-32-bit-wine-1-8-centos-7/#comment-156429
yum install glibc-devel libstdc++-devel icoutils openal-soft-devel prelink gstreamer-plugins-base-devel gstreamer-devel ImageMagick-devel fontpackages-devel libv4l-devel gsm-devel giflib-devel libXxf86dga-devel mesa-libOSMesa-devel isdn4k-utils-devel libgphoto2-devel fontforge libusb-devel lcms2-devel audiofile-devel -y 2>&1 >> $log

yum install openldap-devel libxslt-devel libXcursor-devel libXi-devel libXxf86vm-devel libXrandr-devel libXinerama-devel libXcomposite-devel mesa-libGLU-devel ocl-icd opencl-headers libpcap-devel dbus-devel ncurses-devel libsane-hpaio pulseaudio-libs-devel cups-devel libmpg123-devel fontconfig-devel sane-backends-devel.x86_64 -y 2>&1 >> $log

yum install glibc-devel.i686 dbus-devel.i686 freetype-devel.i686 pulseaudio-libs-devel.i686 libX11-devel.i686 mesa-libGLU-devel.i686 libICE-devel.i686 libXext-devel.i686 libXcursor-devel.i686 libXi-devel.i686 libXxf86vm-devel.i686 libXrender-devel.i686 libXinerama-devel.i686 libXcomposite-devel.i686 libXrandr-devel.i686 mesa-libGL-devel.i686 mesa-libOSMesa-devel.i686 libxml2-devel.i686 libxslt-devel.i686 zlib-devel.i686 gnutls-devel.i686 ncurses-devel.i686 sane-backends-devel.i686 libv4l-devel.i686 libgphoto2-devel.i686 libexif-devel.i686 lcms2-devel.i686 gettext-devel.i686 isdn4k-utils-devel.i686 cups-devel.i686 fontconfig-devel.i686 gsm-devel.i686 libjpeg-turbo-devel.i686 pkgconfig.i686 libtiff-devel.i686 unixODBC.i686 openldap-devel.i686 alsa-lib-devel.i686 audiofile-devel.i686 freeglut-devel.i686 giflib-devel.i686 gstreamer-devel.i686 gstreamer-plugins-base-devel.i686 libXmu-devel.i686 libXxf86dga-devel.i686 libieee1284-devel.i686 libpng-devel.i686 librsvg2-devel.i686 libstdc++-devel.i686 libusb-devel.i686 unixODBC-devel.i686 qt-devel.i686 libpcap-devel.i686 -y 2>&1 >> $log

if [[ "${wine2up}" =~ "${vermajor}" ]]; then
  # for wine 2 and up
  # Thanks to gretzware https://www.systutorials.com/install-32-bit-wine-1-8-centos-7/#comment-157977
  yum install gstreamer1-plugins-base-devel.{x86_64,i686} gstreamer1-devel.{x86_64,i686} systemd-devel.{x86_64,i686} -y 2>&1 >> $log

  # Thanks to gretzware https://www.systutorials.com/install-32-bit-wine-1-8-centos-7/#comment-158134
  yum install libXfixes-devel.{x86_64,i686}  -y 2>&1 >> $log
fi

echo "Download and unpack the wine source package..." 2>&1 | tee -a $log

cd /usr/src 2>&1 >> $log
if [[ "${vermajor}" == "1" ]]; then
  wget http://dl.winehq.org/wine/source/${verurlstr}/wine-${ver}.tar.bz2 -O wine-${ver}.tar.bz2 2>&1 >> $log
  tar xjf wine-${ver}.tar.bz2 2>&1 >> $log
elif [[ "${wine2up}" =~ "${vermajor}" ]]; then
  wget http://dl.winehq.org/wine/source/${verurlstr}/wine-${ver}.tar.xz -O wine-${ver}.tar.xz 2>&1 >> $log
  tar xf wine-${ver}.tar.xz 2>&1 >> $log
fi

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
rm -f $log

# # Uninstall
# cd /usr/src/wine-${ver}/wine32
# make uninstall
# cd /usr/src/wine-${ver}/wine64
# make uninstall

