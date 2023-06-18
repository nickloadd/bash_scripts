#!/bin/bash

PPP_GW_ADD=`./getip.sh ppp0`                       #get peer ip 
ip route del 192.168.1.3 via $PPP_GW_ADD dev ppp0  #drop route

#down connection
ipsec auto --down L2TP-PSK 
echo "d vpn-connection" > /var/run/xl2tpd/l2tp-control
systemctl stop xl2tpd
systemctl stop ipsec