#!/bin/env bash

# Warning: change the email addresses below to yours.

# Written by Eric Ma ( https://www.ericzma.com )

# Requirment:
# 1. Use gitolite https://www.systutorials.com/how-to-set-up-gitolite-git-server-a-ten-minute-tutorial/
# 2. Use the script for email notification https://www.systutorials.com/setting-up-git-commit-email-notification/
# 3. The post-receive script is in $HOME/ and is set to be executable

# configuration
senderemail="git-notification@ericzma.com"
receiveremails="zma@ericzma.com"

if [ $# -lt 1 ]; then
    echo "Usage: $0 repo_dir_name"
    echo "Example: $0 test.git"
    exit 1
fi

repo=$1
repo_dir=$HOME/repositories/$repo

echo "Set in $repo_dir:"

cd $repo_dir

grep "\[hooks\]" config >/dev/null

if [ $? -eq 0 ]; then
    echo "Hooks in config already set. skip"
else
    echo -e "[hooks]\n   mailinglist = \"$receiveremails\"\n   senderemail = \"$senderemail\"" >> config
fi

if [ -e description ]; then
    echo "description already exists. skip"
else
    echo "$repo" > description
fi

cd hooks
if [ -e post-receive ]; then
    echo "post-receive already exists. skip"
else
    ln -s ../../../post-receive ./
fi

echo "Done."
