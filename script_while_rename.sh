# !/bin/bash


find ~/bin/dir_rename/ -name '*.jpg' |
while read FN
do echo $FN $(dirname $FN)/$(basename $FN .jpg).jpeg ; done |
xargs -n2 -P $(nproc) mv 
