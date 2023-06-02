#!/bin/bash

useradd -m -s /bin/bash $1
mkdir /home/$1/.ssh/
touch /home/$1/.ssh/authorized_keys
echo 'PUB_KEY' > /home/$1/.ssh/authorized_keys
chown -R $1:$1 /home/$1/.ssh/
chmod -R 700 /home/$1/.ssh/
chmod -R 600 /home/$1/.ssh/authorized_keys
usermod -aG sudo $1