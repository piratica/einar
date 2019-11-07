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

echo If this is the first run, you will get an error that SERIAL does not exist.  This is normal.
source config.sh

LOKIHOME=$(pwd)
# sed -i 's/^LOKIHOME="*"/LOKIHOME="$LOKIHOME"/g' config.sh
sed -i "s|^LOKIHOME.*$|LOKIHOME=$(pwd)|g" config.sh

MYNAME=$(dmidecode -s system-serial-number)

if [ -z "$(pwd)/SERIAL" ]; then
	touch $(pwd)/SERIAL
	$ECHO "Creating serial file"
fi
$ECHO $MYNAME > $(pwd)/SERIAL

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
if [ -z "$C2USER" ]; then
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
	
	# Now, update the CONFIG line to point to the correct config
	sed -i "s|^CONFIG.*$|source $LOKIHOME/config.sh|g" $LOKIHOME/$MYNAME-cron.sh	
fi

# Setup the phonehome.sh script
$MV $LOKIHOME/phonehome.sh $LOKIHOME/$MYNAME-phonehome.sh 
$CHMOD +x $LOKIHOME/$MYNAME-phonehome.sh 
sed -i "s|^CONFIG.*$|source $LOKIHOME/config.sh|g" $LOKIHOME/$MYNAME-phonehome.sh

# Setup the uninstall.sh script
$CHMOD +x $LOKIHOME/uninstall.sh 
sed -i "s|^CONFIG.*$|source $LOKIHOME/config.sh|g" $LOKIHOME/uninstall.sh 

# Add a crontab for root to start the services on reboot
if ! [ -f /var/spool/cron/crontabs/root ]; then
	touch /var/spool/cron/crontabs/root
	$LOG "Created crontab for root, there wasn't one"
fi

# Update root's crontab 
if ! grep -q "onboot" /var/spool/cron/crontabs/root; then
    echo @reboot $LOKIHOME/$MYNAME-onboot.sh > /var/spool/cron/crontabs/root
	update-rc.d cron defaults
	$LOG "Crontab entry to start service not found, adding"
	$LOG "99999999 testbob"
fi

if ! grep -q "checknet" /var/spool/cron/crontabs/root; then
	echo "*/1 * * * * $LOKIHOME/$MYNAME-checknet.sh" >> /var/spool/cron/crontabs/root
	update-rc.d cron defaults
	$LOG "Crontab entry to start service not found, adding"
	$LOG "888888 testbob"
fi
if ! grep -q "postqueue" /var/spool/cron/crontabs/root; then
	echo "*/5 * * * * /bin/bash $POSTQ -f" >> /var/spool/cron/crontabs/root
	$LOG "Added mail flush to root crontab"
fi

# check for cron job to check in and, if it isn't there, add it
$CRONTAB -u $C2USER -l | grep $MYNAME 
if [ $? == 1 ]; then 
  $LOG "No crontab found, Adding Crontab"
  echo "*/$CALLHOMEFREQ  * * * * $LOKIHOME/$MYNAME-cron.sh > /dev/null 2>&1" >> /var/spool/cron/crontabs/$C2USER
  $CHMOD 600 /var/spool/cron/crontabs/$C2USER
fi

$MV $LOKIHOME/onboot.sh $LOKIHOME/$MYNAME-onboot.sh
$CHMOD +x $LOKIHOME/$MYNAME-onboot.sh
$MV $LOKIHOME/checknet.sh $LOKIHOME/$MYNAME-checknet.sh
$CHMOD +x $LOKIHOME/$MYNAME-checknet.sh 

sed -i "s|^CONFIG.*$|source $LOKIHOME/config.sh|g" $LOKIHOME/$MYNAME-onboot.sh
sed -i "s|^CONFIG.*$|source $LOKIHOME/config.sh|g" $LOKIHOME/$MYNAME-checknet.sh

###########################################################
## Switching to systemd here :(
#$ECHO $LOKIHOME/$MYNAME-onboot.sh >> /etc/rc.local
#$CHMOD +x /etc/rc.local 
#$CHMOD +x $LOKIHOME/$MYNAME-onboot.sh
# We should have everything setup now.  
#$LOKIHOME/$MYNAME-onboot.sh
$LOG "Setting up systemd"
sed -i "s|LOKIHOME|$LOKIHOME|g" einar.service
sed -i "s|MYNAME|$MYNAME|g" einar.service
mv einar.service /etc/systemd/system/
chmod 664 /etc/systemd/system/einar.service
systemctl daemon-reload
systemctl enable einar.service
#$LOG "Finished setting up systemd"
service einar start
$LOKIHOME/$MYNAME-onboot.sh 
