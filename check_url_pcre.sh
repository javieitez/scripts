#!/bin/bash

# Author: JA Vieitez (github.com/javieitez)

# Quick and dirty script to find a Perl Compatible Regex in the output of a URL. Unlike the bundled Regex functionality of check_http, this one supports multiline expressions :) 


# help requested or invalid parameters
#############################################################
if  [ -z "$1" ]
	then 
	echo "Invalid input. Please use --help for options."
	exit 0
fi

if [ "$1" == '-h' ] 
	then 
	NEEDHELP='true'
fi

if [ "$1" == '--help' ] 
	then 
	NEEDHELP='true'
fi

if [ "$NEEDHELP" == 'true' ] 
	then
		echo "find a Perl compatible Regex in a web page"
		echo ""
		echo "Usage:  check_url_pcre hostname path REGEX [--http]"
		echo ""
		echo "HTTPS is enabled by default, use -HTTP to disable it"
		echo "Example: check_url_pcre www.example.com /statistics.html '.*connected users.*\n.*([1-8][0-9]|90)'"
		exit 3
fi
#############################################################
# Set to http if specified, default to https

PROTOCOL="https"
if [ "$4" == "--http" ] 
	then
		PROTOCOL="http"
fi

#############################################################

echo "fetching $PROTOCOL://$1$2..."

curl --silent "$PROTOCOL://$1$2" | pcregrep -M "$3"

#capture the exit code
LASTEXITCODE=$?

echo "$LASTEXITCODE"

if [ "$LASTEXITCODE" == 0 ] 
	then
		# No alarms? Ok, everything is right.
		echo "OK - Perl Compatible Regular expression found in $PROTOCOL://$1$2"
		exit 0
	else
		echo "CRITICAL - REGEX NOT FOUND IN $PROTOCOL://$1$2"
		exit 2
fi
