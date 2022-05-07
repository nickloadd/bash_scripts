# !/bin/bash

usage () {
 echo "Example of usage: $(basename $0) name | /.../libname.so.[0-9]" >&2
 exit 1
}

[ -z $1 ] && usage

ldpath=$(grep -h '^[^#]' /etc/ld.so.conf.d/*.conf)

case $1 in
 /*/lib*.so.[0-9]) what=$1;;
 *) what=$(find $ldpath -name "lib$1.so.[0-9]" 2>/dev/null);;
esac

if [ -z $what ]
 then echo "Library $1 not found in $ldpath"
 usage
fi

where=$(printenv PATH | tr ':' ' ')

for lib in $what
do
  find $where -type f |
  xargs file -L |
  grep ':.*ELF' |
  cut -f 1 -d : |
  while read exe
   do 
    ldd $exe | grep -q $lib && echo $exe
   done
done
