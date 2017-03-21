#!/bin/bash

# Download, build and install wine 32-bit on CentOS 7

# For details of this script, please check
# https://www.systutorials.com/239913/install-32-bit-wine-1-8-centos-7/

# Author: Eric Zhiqiang Ma (zma@ericzma.com)

set -o errexit

log=`mktemp -t install-wine.XXXXXX.log`

# Install

ver=1.8.5

echo "Hello there. Start to download, build and install wine $ver 32-bit and 64-bit versions..." | tee $log
echo "Logs are in $log" | tee -a $log

echo "Uninstall old wine64 if you have installed it. Please select yes..." | tee -a $log

yum erase wine wine-*

echo "Install wine building tools..." | tee -a $log

yum install samba-winbind-clients -y 2>&1 >>$log
yum groupinstall 'Development Tools' -y 2>&1 >> $log
yum install libjpeg-turbo-devel libtiff-devel freetype-devel -y 2>&1 >> $log
yum install glibc-devel.{i686,x86_64} libgcc.{i686,x86_64} libX11-devel.{i686,x86_64} freetype-devel.{i686,x86_64} gnutls-devel.{i686,x86_64} libxml2-devel.{i686,x86_64} libjpeg-turbo-devel.{i686,x86_64} libpng-devel.{i686,x86_64} libXrender-devel.{i686,x86_64} alsa-lib-devel.{i686,x86_64} -y 2>&1 >> $log

echo "Download and unpack the wine source package..." 2>&1 | tee -a $log

cd /usr/src 2>&1 >> $log
wget http://dl.winehq.org/wine/source/1.8/wine-${ver}.tar.bz2 -O wine-${ver}.tar.bz2 2>&1 >> $log
tar xjf wine-${ver}.tar.bz2 2>&1 >> $log

echo "Build wine..." 2>&1 | tee -a $log
cd wine-${ver}/ 2>&1 >> $log
mkdir -p wine32 wine64 2>&1 >> $log

echo "   build wine64..." 2>&1 | tee -a $log
cd wine64 2>&1 >> $log
../configure --enable-win64 2>&1 >> $log
make -j 4 2>&1 >> $log

echo "   build wine32..." 2>&1 | tee -a $log
cd ../wine32 2>&1 >> $log
../configure --with-wine64=../wine64 2>&1 >> $log
make -j 4 2>&1 >> $log

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

