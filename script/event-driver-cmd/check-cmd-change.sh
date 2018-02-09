#!/bin/bash

# Eric Zhiqiang Ma (http://www.ericzma.com)

# Example
# ./check-cmd-change.bash "node-status" "(for i in 10.0.3.{2..50}; do echo $i; ssh $i 'dmesg | grep error'; done)" 'mailx -S smtp="smtp://smtp.ust.hk" -s "dmesg error monitor @wiles" -r zma@connect.ust.hk zma@connect.ust.hk'

if [[ $# < 3 ]]; then
    echo "Usage: $0 id 'watched cmd' 'trigger cmd'"
    exit 1;
fi

id=$1
cmd=$2
trigger=$3

oldfile=/var/tmp/check-cmd-change-$id-old-$USER
newfile=/var/tmp/check-cmd-change-$id-new-$USER
difffile=/var/tmp/check-cmd-change-$id-diff-$USER

for f in $oldfile $newfile; do
    if [ ! -f $f ]; then
        touch $f
    fi
done

mv $newfile $oldfile

eval $cmd >$newfile

diff -u ${oldfile} ${newfile} >$difffile
if [[ $? == 1 ]]; then
    echo "===============" >>$difffile
    cat $difffile $newfile | eval $trigger
fi

