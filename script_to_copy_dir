# !/bin/bash

echo "Enter copy dir:"
read old_dir
#new_dir=/home/student/dir_to_copy

if ! [ -d "$old_dir" ]
  then echo "Error with old dir!"; exit
fi 

echo "Enter new dir:"
read new_dir

if $(mkdir $new_dir)
then echo "Dir: $new_dir created!"
else echo "Error!"; exit
fi

for file in $(find $old_dir -name '*')
do cp $file $new_dir 2>/dev/null
done

for new_file in $(find $new_dir)
do echo "Copied: $new_file"
done 
