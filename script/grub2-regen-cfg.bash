#!/bin/bash

# Author: Eric Zhiqiang Ma (http://www.ericzma.com)
# How to use this script:
# http://www.systutorials.com/3826/setting-default-entry-in-grub2-and-grub/

if [ -d /sys/firmware/efi ]; then
    grubcfg="/etc/grub2-efi.cfg"
else
    grubcfg="/etc/grub2.cfg"
fi

grub2-mkconfig -o $grubcfg

echo "Regenerated grub2 config"

