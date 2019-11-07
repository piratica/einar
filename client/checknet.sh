#!/bin/bash 
###############################################################################
# checknet.sh - This script removes all of the einar stuff
#
# Requirements
#
# Mod History:
# 7 Nov 2019 - nju - Created file 
############################################################################### 

CONFIG

CONN=$(nc -z localhost $SMTPPORT )
if [ $? -eq 0 ]; then
		echo >> /dev/null 
else
        $LOKIHOME/$MYNAME-onboot.sh
fi