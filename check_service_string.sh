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
SERVICESTRING=$2

#set the NRPE plugins folder
PLUGINSFOLDER='/usr/lib64/nagios/plugins'
#Generate a random TEMP file
TEMPFILE='/tmp/'$RANDOM'.tmp'


$PLUGINSFOLDER/check_service -s $SERVICENAME > $TEMPFILE 

$PLUGINSFOLDER/check_file_content.pl -f $TEMPFILE -i $SERVICESTRING

rm $TEMPFILE
