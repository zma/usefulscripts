#!/bin/bash
#
# Find the Chrome bookmarks file by account <email>
# and save a copy into file <resultpath>
#
# Authors: Eric Ma (https://www.ericzma.com)
#
# Usage:
#    ./show-chrome-bookmarks.sh <email> <resultpath>
#

profileemail=$1
resultpath=$2

if [[ "$profileemail" == "" || "$resultpath" == "" ]]; then
  echo "Usage: $0 <email> <resultpath>"
  exit 1
fi

profiledir="$HOME/.config/google-chrome"
if [[ ! -d "$profiledir" ]]; then
  # try mac ?
  profiledir="$HOME/Library/Application Support/Google/Chrome"
fi
if [[ ! -d "$profiledir" ]]; then
  echo "ERROR: can't find the chrome profile directory." 2>&1
  exit 3
fi

if [[ "$resultpath" == "-" ]]; then
  savecmd="cat"
else
  savecmd="cat > $resultpath"
fi

for d in "${profiledir}"/*; do
  if [[ -f "$d/Preferences" ]]; then
    email=$(jq '.account_info[0].email' "$d/Preferences" | tr -d '"')
    if [[ "$email" == "$profileemail" ]]; then
      cat "$d/Bookmarks" | eval "$savecmd"
      exit 0
    fi
  else
    continue
  fi
done

