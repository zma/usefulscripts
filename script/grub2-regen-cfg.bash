#!/bin/bash

# Author: Eric Ma (https://www.ericzma.com)
# How to use this script:
# https://www.systutorials.com/how-to-regenerate-grub2-config-file-on-linux/

if [ -d /sys/firmware/efi ]; then
    grubcfg="/etc/grub2-efi.cfg"
else
    grubcfg="/etc/grub2.cfg"
fi

# make a backup just in case
cp $grubcfg $grubcfg-grub2-regen-cfg.bak

# regenerate the config file now
grub2-mkconfig -o $grubcfg

echo "Regenerated grub2 config"

