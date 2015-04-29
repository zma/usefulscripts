#!/bin/bash

# Author: Eric Zhiqiang Ma (http://www.ericzma.com)
# How to use this script:
# http://www.systutorials.com/136638/how-to-regenerate-grub2-config-file-on-linux/

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

