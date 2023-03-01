# !/bin/bash

for node in $(seq 1 254)
do
 if $(ping -c 1 -W 1 192.168.31.$node 1>/dev/null)
  then echo 192.168.31.$node
  fi
done
