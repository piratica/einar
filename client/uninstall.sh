#!/bin/bash 
###############################################################################
# uninstall.sh - This script removes all of the einar stuff
#
# Requirements
#
# Mod History:
# 7 Nov 2019 - nju - Created file 
############################################################################### 

CONFIG
$SYSTEMCTL disable einar
$SYSTEMCTL daemon-reload
$RM -rf /var/spool/cron/crontabs/psa
$SED -i '/-onboot.sh/d' /var/spool/cron/crontabs/root

cd $LOKIHOME
cd .. 
echo "Einar is disabled.  You will now need to remove the $LOKIHOME directory with # rm -rf $LOKIHOME "