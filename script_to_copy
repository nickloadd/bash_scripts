# !/bin/bash

new_dir=/home/student/dir_to_copy


if [ $(stat $new_dir 2>/dev/null) ]
then echo "Dir already exist!"
else $(mkdir $new_dir)
fi

for file in $(find ~/bin/ -name 'script*')
do cp $file $new_dir
done

for new_file in $(find $new_dir)
do echo "Copied: $new_file"
done 
