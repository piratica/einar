#/bin/bash

DESTEMAIL=""
C2=""				# This is the C2 server that you'll connect to
C2PROTO="HTTP://"	# Use HTTPS:// or HTTP:// for now
C2USER=""			# This is a local, non-privileged user on the device that will log into C2 (via SSH)
FRIENDLY_NAME=""	# This is a friendly name for this device that will be in the body of the proof of life email

SSHPORT=			# The port you'll use to connect to SSH on C2
PROXYPORT=2223		# The port you'll use for the reverse SSH tunnel
SMTPPORT=2525		# We'll tunnel SSH from C2 to here so that we can relay mail
LOKIHOME=""			# Leave This Alone, it will get updated during provisioning
COMMANDFILE=$MYNAME
CALLHOMEFREQ=2		# How frequently, in minutes, do we check for commands

# Check for necessary commands and create variables for them (or errors if they aren't there)

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
MYNAME=$(cat $LOKIHOME/SERIAL)
NC=$(which nc)
NMAP=$(which nmap)
PIDOF=$(which pidof)
RM=$(which rm)
SSH=$(which ssh)
SUDO=$(which sudo)
SYSTEMCTL=$(which systemctl)
TOUCH=$(which touch)
WGET=$(which wget)