#!/bin/bash

ifconfig $1 | grep "inet" | awk '{print $2}' #get ip of ppp0 if