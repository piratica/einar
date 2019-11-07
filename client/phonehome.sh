#!/bin/bash 
###############################################################################
# phonehome.sh - This gathers pertinent info on the RSA and emails it to 
#                $DESTEMAIL
#
# Requirements
#
# Mod History:
# 9 Oct 2019 - nju - Created file 
############################################################################### 

CONFIG

# Gather info
$LOG "[EINAR] Gathering info for message"
WAN_IP=$(curl ifconfig.me)
LAN_IP=$(ip ad | grep inet | awk '{print $2}' )
#SERIAL=$(dmidecode -s system-serial-number)
SERIAL=$(cat /opt/einar/client/SERIAL)
UPTIME=$(uptime)
MAC=$(/sbin/ifconfig eno1 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')

if [ -n "$FRIENDLY_NAME" ]; then
	$MYNAME = $FRIENDLY_NAME
else
	$MYNAME = $SERIAL
fi

$ECHO "Details for $MYNAME" > /opt/einar/client/netinfo 
$ECHO "LAN IP = $LAN_IP " >> /opt/einar/client/netinfo
$ECHO "WAN IP = $WAN_IP" >> /opt/einar/client/netinfo
$ECHO "SSH Proxy Port = $PROXYPORT" >> /opt/einar/client/netinfo 
$ECHO $MSG >>  /opt/einar/client/netinfo
$ECHO "===========================" >> /opt/einar/client/netinfo
$ECHO "Serial = $SERIAL" >> /opt/einar/client/netinfo
$ECHO "MAC = $MAC" >> /opt/einar/client/netinfo
$ECHO "Uptime = $UPTIME" >> /opt/einar/client/netinfo
# Send proof of life email
#/usr/bin/mail -s "PSA ONLINE $FRIENDLY_NAME" nathan@piratica.us < /opt/einar/client/netinfo
cat /opt/einar/client/netinfo | mail nathan@piratica.us -s "PSA $MYNAME ONLINE"
# We done 