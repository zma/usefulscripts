#!/bin/bash

# Eric Zhiqiang Ma (http://www.ericzma.com)

# Example
#   check-cmd-timeout.sh "node-status" "/paht/cmd/may/timeout" 'mailx -S smtp="smtp://smtp.ust.hk" -s "cmd timeout @`hostname`" -r zma@connect.ust.hk zma@connect.ust.hk'

killtree() {
    # echo "kill $@"
    local _pid=$1
    local _sig=${2:-TERM}
    # kill -stop ${_pid} # needed to stop quickly forking parent from producing children between child killing and parent killing
    for _child in $(ps -o pid --no-headers --ppid ${_pid}); do
        killtree ${_child} ${_sig}
    done
    kill -${_sig} ${_pid}
}

if [[ $# < 2 ]]; then
    echo "Usage: $0 id 'watched cmd' timeout_in_seconds 'trigger cmd'"
    exit 1;
fi

id=$1
cmd=$2
timeout=$3
trigger=$4

stdoutfile=/tmp/check-cmd-timeout-$id-$USER

for f in $stdoutfile ; do
    if [ ! -f $f ]; then
        touch $f
    fi
done

pidFile=/tmp/check-cmd-timeout-pid-$id-$USER

( eval $cmd 2>&1 >$stdoutfile ; rm $pidFile ; ) &
pid=$!
echo $pid > $pidFile

( sleep $timeout ; if [[ -e $pidFile ]]; then eval $trigger; killtree $pid ; fi ; ) &
killerPid=$!

wait $pid && kill $killerPid

