#!/bin/bash

# Shutdown all VMs managed by Xen
# For newer versions of Xen using xl, xm should be replaced with xl
# Author: Zhiqiang Ma http://www.zhiqiangma.com

for i in `xm list -l | grep '(name' | grep -v Domain | cut -d'(' -f2 | cut -d' ' -f2 | cut -d')' -f1`; 
do 
  echo $i; 
  xm shutdown $i;
done;
