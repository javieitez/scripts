#!/bin/bash

#Script for retrieving a series of log files and counting repetitions of a given string in them

# Valid for a colllection of servers named something like BACKEND-01, BACKEND-02, etc...

#The logs must be accessible throug HTTP (usually in internal networks), otherwise the script must be modified to get the files via SFTP or oher method

# Think of this script more like a template of ideas on how to porcess a log file 

# Author: JA Vieitez

SERVERPREFIX=BACKEND-
SERVERRANGE={1..15}

# Remove old Temp files and fetch latest versions
for SERVERNUMBER in SERVERRANGE
	do
		#clear previous file if it exists
		rm /tmp/$SERVERPREFIX$SERVERNUMBER.txt
		wget http://$SERVERPREFIX$SERVERNUMBER/$SERVERPREFIX$SERVERNUMBER -P /tmp/
	done

# parse the logs and count the repetitions
for SERVERNUMBER in SERVERRANGE
	do		
		echo Number of ocurrences for $SERVERNUMBER > /var/www/logfiles/$SERVERPREFIX$SERVERNUMBER.txt
		#Search for a string, count the number of ocurrences with wc and save it to a local path. The resulting file can be parsed by a Nagios check that can trigger an alarm
		awk '/string to parse/ {print $4}' /tmp/$SERVERPREFIX$SERVERNUMBER.txt | sort | uniq | wc -l  >> /var/www/logfiles/$SERVERPREFIX$SERVERNUMBER.txt
	done

