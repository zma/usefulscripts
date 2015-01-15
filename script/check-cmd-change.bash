#!/bin/bash

# Eric Zhiqiang Ma (http://www.ericzma.com)
# Example
# ./check-cmd-change.bash "(for i in 10.0.3.{2..50}; do echo $i; ssh $i 'dmesg | grep error'; done)" 'mailx -S smtp="smtp://smtp.ust.hk" -s "dmesg error monitor @wiles" -r zma@connect.ust.hk zma@connect.ust.hk'

if [[ $# < 2 ]]; then
    echo "Usage: $0 'watched cmd' 'trigger cmd'"
    exit 1;
fi

cmd=$1
trigger=$2

oldfile=/tmp/check-cmd-change-old-$USER
newfile=/tmp/check-cmd-change-new-$USER
difffile=/tmp/check-cmd-change-diff-$USER

for f in $oldfile $newfile; do
    if [ ! -f $f ]; then
        touch $oldfile
    fi
done

mv $newfile $oldfile

eval $cmd >$newfile

diff -u ${oldfile} ${newfile} >$difffile
if [[ $? == 1 ]]; then
    echo "===============" >>$difffile
    cat $difffile $newfile | eval $2
fi
