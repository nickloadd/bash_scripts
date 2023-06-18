#!/bin/bash

systemctl start ipsec
sleep 2                                                   #delay to ensure that IPsec is started before overlaying L2TP
systemctl start xl2tpd
ipsec auto --up L2TP-PSK                                  #up connection
echo "c vpn-connection" > /var/run/xl2tpd/l2tp-control
sleep 2                                                   #delay again to make that the PPP connection is up

PPP_GW_ADD=`./getip.sh ppp0`

ip route add 192.168.1.3 via $PPP_GW_ADD dev ppp0         #add route via tunnel to target address