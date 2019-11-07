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
$RM -rf /var/spool/cron/crontabs/psa
$SED -i '/-onboot.sh/d' /var/spool/cron/crotabs/root
$RM -rf $LOKIHOME
echo "Einar removed"