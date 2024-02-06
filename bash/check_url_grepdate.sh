#!/bin/bash

# Author: JA Vieitez (github.com/javieitez)

# Quick and dirty script to find a Date stamp in a URL. This is useful for checking logs to be up to date, or to check a proper refreshing of a given webservice.  
# Check the date command man page for date options

# help requested or invalid parameters
#############################################################
printhelp () {
	echo "find the current date and time in a web page"
	echo ""
	echo "Usage:  check_url_grepdate hostname path date_options [--http]"
	echo ""
	echo "HTTPS is enabled by default, use -HTTP to disable it"
	echo "Example: check_url_grepdate www.example.com /log.html '+%Y%m%d\ %H:%M'"	
	exit 3
	}

if [ "$1" == '-h' ] ||  [ "$1" == '--help' ]  || [ -z "$1" ] || [ -z "$2" ]
	then 
	printhelp
fi



#############################################################
# Set to http if specified, default to https
PROTOCOL="https"

if [ "$4" == "--http" ] 
	then
		PROTOCOL="http"
fi

#############################################################
#Generate the date timestamp
MYTIMESTAMP=`date '$3'`

if [ "$3" == "" ]  ||  [ "$MYTIMESTAMP" == "" ]
	then
		printf "\nNo valid operand supplied. Please provide a valid date one.\n\n\n\n"
		printhelp
		
fi

#Run the command
curl --silent "$PROTOCOL://$1$2" | grep  "$MYTIMESTAMP"

#capture the exit code
LASTEXITCODE=$?

#return output based on the exit code
if [ "$LASTEXITCODE" == 0 ] 
	then
		# No alarms? Ok, everything is right.
		printf "\nOK - $MYTIMESTAMP found in $PROTOCOL://$1$2\n"
		exit 0
	else
		printf "\nCRITICAL - $MYTIMESTAMP NOT FOUND IN $PROTOCOL://$1$2\n"
		exit 2
fi
