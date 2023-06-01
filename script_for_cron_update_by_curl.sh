#!/bin/sh

#Getting maxmind license key via env cronjob
license_key=$KEY

#Creating url to maxmind
url="https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country&license_key=${license_key}&suffix=tar.gz"
#Getting remote version db
remote_name=$(curl -I -s $url | grep -E "filename=" | cut -d= -f2 | sed 's/.$//')
#Getting local version db
local_name=$(ls ./ | grep -E "GeoLite2-Country_.*.tar.gz")

#Body
if [ -z $local_name ] || [ "$local_name" != "$remote_name" ] ; then
  echo "Downloading maxmind db version \"${remote_name%.*.*}\""
  curl --connect-timeout 30 --retry-delay 5 --retry 5 -s --output ./$remote_name -J $url
  if [ $? != 0 ]; then echo "[ERR] download error" && exit 1; fi
  tar -xzf ./$remote_name --strip-components=1  -C ./ `tar -tzf ./$remote_name | grep -E ".*.mmdb"`
  if [ $? != 0 ]; then echo "[ERR] extract error" && exit 1; fi
  if [ -z $local_name ]; 
    then echo "Successful download maxmind db \"${remote_name%.*.*}\" version"
  else
    rm -rf ./$local_name && echo "Successful update maxmind db to \"${remote_name%.*.*}\" version"; 
  fi
else
    echo "Nothing to update: local db version \"${local_name%.*.*}\" is actual"
fi