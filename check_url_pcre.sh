#!/bin/bash

# Author: JA Vieitez (github.com/javieitez)

# Quick and dirty script to find a Perl Compatible Regex in the output of a URL. Unlike the bundled Regex functionality of check_http, this one supports multiline expressions :) 

# help requested or invalid parameters
#############################################################
printhelp () {
	echo "find a Perl compatible Regex in a web page"
	echo ""
	echo "Usage:  check_url_pcre hostname path REGEX [--http]"
	echo ""
	echo "HTTPS is enabled by default, use -HTTP to disable it"
	echo "Example: check_url_pcre www.example.com /statistics.html '.*connected users.*\n.*([1-8][0-9]|90)'"
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
#Run the command
curl --silent "$PROTOCOL://$1$2" | pcregrep -M "$3"

#capture the exit code
LASTEXITCODE=$?

#return output based on the exit code
if [ "$LASTEXITCODE" == 0 ] 
	then
		# No alarms? Ok, everything is right.
		echo "OK - Perl Compatible Regular expression found in $PROTOCOL://$1$2"
		exit 0
	else
		echo "CRITICAL - REGEX NOT FOUND IN $PROTOCOL://$1$2"
		exit 2
fi
