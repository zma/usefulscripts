#!/bin/bash

# Eric Ma (https://www.ericzma.com)

# Example
#   do-after-change.sh make *.c *.h Makefile

cmdfile=/tmp/doafterchanges
touch $cmdfile

if [ $# -lt 2 ]; then
    echo "Usage: $0 cmd watched_files"
    exit 1
fi

which inotifywait 2>&1 >/dev/null

if [ "$?" == "1" ]; then
    echo "You need inotifywait installed"
    exit 1
fi

cmd=$1
shift
files=$*

function exec_cmd () {
    echo "[`date`] >>>> Run: $cmd"
    eval $cmd
    echo "[`date`] >>>> Exit code: $?"
}

# do it first
exec_cmd

while true; do
    # inotifywait -t 60 -q -r $files
    inotifywait -q -r $files $cmdfile
    exec_cmd
done
