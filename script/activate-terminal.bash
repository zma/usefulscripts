#!/usr/bin/env bash

# Written by Eric Zhiqiang Ma (http://www.ericzma.com)
# Last update: Jul. 9, 2014

# Required tools: xdotool

state_file="/dev/shm/actiavte-termianl.term.$USER"
termtype="Terminal"
wait_sec=1
max_wait_cnt=4

term_exists () {
    allterms=`xdotool search --class "$termtype"`
    for e in $allterms; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}

create_terminal () {
    echo "Create new terminal"
    gnome-terminal --maximize &

    exists=1
    wait_cnt=0
    until [ "$exists" == "0" ]; do
        # sleep a while
        sleep $wait_sec

        # Note that the focus window may be from a terminal that
        # already exists; the makes create_terminal choose the existing terminal
        # Making the wait_sec large enough so that the terminal can be created and
        # displayed can make the false choosing more unlikely.

        term=$(xdotool getwindowfocus)
        term_exists "$term"
        exists=$?
        # avoid infinite wait
        let wait_cnt=wait_cnt+1
        if [ $wait_cnt -gt $max_wait_cnt ]; then
            echo "Wait for too long. Give up."
            term=""
            exists=0
        fi
    done

    echo "Created terminal window $term"
    # save the state
    echo "$term" >$state_file
}

# read the state
term=$(cat $state_file)

# check whether it exists
term_exists "$term"
exists=$?
if [[ "$exists" != "0" ]]; then
    create_terminal
    exit 0
fi

# check whether it is already activated
curwin=$(xdotool getwindowfocus)

if [ "$term" == "$curwin" ]; then
    # deactivate (minimize) the terminal if it is currently activated
    xdotool windowminimize $curwin
else
    # activate the terminal if it is not currently activated
    xdotool windowactivate $term
fi

exit 0
