#!/bin/bash

# The best way is to run that script after \resource "aws_volume_attachment"\ created
sleep 120

# Format and mount an attached volume
DEVICE_ZOOKEEPER="$(lsblk | grep 50G | awk '{print $1}')"
MOUNT_POINT_ZOOKEEPER="/opt/zookeeper/data"

echo "MOUNT_POINT_ZOOKEEPER=$MOUNT_POINT_ZOOKEEPER"

echo "DEVICE_ZOOKEEPER=$DEVICE_ZOOKEEPER"

mkdir -p $MOUNT_POINT_ZOOKEEPER

mkfs -t ext4 "/dev/$DEVICE_ZOOKEEPER"

mount "/dev/$DEVICE_ZOOKEEPER" $MOUNT_POINT_ZOOKEEPER

# Automatically mount an attached volume after reboot / For the current task it's not obligatory
cp /etc/fstab /etc/fstab.orig
UUID_ZOOKEEPER=$(blkid | grep $DEVICE_ZOOKEEPER | awk -F '\"' '{print $2}')

echo "UUID_ZOOKEEPER=$UUID_ZOOKEEPER"

echo -e "UUID=$UUID_ZOOKEEPER     $MOUNT_POINT_ZOOKEEPER      ext4    defaults,nofail   0   2" >> /etc/fstab

umount /opt/zookeeper/data

mount -a

# Change user for data operations / Non mandatory
chown -R ubuntu:ubuntu $MOUNT_POINT_ZOOKEEPER