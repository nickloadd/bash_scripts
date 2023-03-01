# !/bin/bash

[ -n "$1" -a -f "$2" ] &&
sed -i -e "/$1/ s/^#//" -e t -e "/$1/ s/^/#/" $2 ||
echo "Usage: script-toggle RE file"
