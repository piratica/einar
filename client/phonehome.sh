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
SERIAL=$(cat $LOKIHOME/SERIAL)
UPTIME=$(uptime)
MAC=$(/sbin/ifconfig eno1 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')

if [ -n "$FRIENDLY_NAME" ]; then
	$$LOG "Friendly name already set"
else
	$FRIENDLY_NAME = $SERIAL
fi

$ECHO "Details for $MYNAME" > $LOKIHOME/netinfo 
$ECHO "LAN IP = $LAN_IP " >> $LOKIHOME/netinfo
$ECHO "WAN IP = $WAN_IP" >> $LOKIHOME/netinfo
$ECHO "SSH Proxy Port = $PROXYPORT" >> $LOKIHOME/netinfo 
$ECHO $MSG >>  $LOKIHOME/netinfo
$ECHO "===========================" >> $LOKIHOME/netinfo
$ECHO "Serial = $SERIAL" >> $LOKIHOME/netinfo
$ECHO "MAC = $MAC" >> $LOKIHOME/netinfo
$ECHO "Uptime = $UPTIME" >> $LOKIHOME/netinfo
# Send proof of life email
#/usr/bin/mail -s "PSA ONLINE $FRIENDLY_NAME" nathan@piratica.us < $LOKIHOME/netinfo
cat $LOKIHOME/netinfo | mail nathan@piratica.us -s "PSA $MYNAME ONLINE"
# We done 