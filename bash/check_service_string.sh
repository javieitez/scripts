#!/bin/bash

# Quick and dirty script to save the status of a service to a temp file, then search it for a string
#
# Author: JA Vieitez
#
# Requires check_file_content.pl
# https://raw.githubusercontent.com/deimosfr/nagios-check_file_content/master/check_file_content.pl
#
#Requires check_service
#https://raw.githubusercontent.com/jonschipp/nagios-plugins/master/check_service.sh
# 
# the three files share the scripts path

#get the service and string to search from the command arguments
SERVICENAME=$1
UPSTRING=$2
DOWNSTRING=$3

if [ $1 == '-h' ]
	then
		echo "Usage:  check check_service_string service STRING1 STRING2"
		echo "The first parameter is the service UP status string, the second one is the service down"
		echo ""
		echo "Example: check check_service_string nrpe running dead"
		exit 3
fi

#set the NRPE plugins folder
PLUGINSFOLDER='/usr/lib64/nagios/plugins'
#Generate a random TEMP file
TEMPFILE='/tmp/'$RANDOM'.tmp'

#save service status to a temp file
$PLUGINSFOLDER/check_service -s $SERVICENAME > $TEMPFILE 

#search for the string in tmp file
$PLUGINSFOLDER/check_file_content.pl -f $TEMPFILE -i $UPSTRING -e $DOWNSTRING > /dev/null
#capture the exit code
LASTEXITCODE=$? 

rm $TEMPFILE

if [ $LASTEXITCODE == 0 ] 
	then
		# No alarms? Ok, everything is right.
		echo "OK - $SERVICENAME is $UPSTRING"
		exit 0
	else
		echo "CRITICAL - $SERVICENAME is $DOWNSTRING"
		exit 2
fi
