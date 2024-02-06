#!/bin/bash

# Author: JA Vieitez (github.com/javieitez)

# find a Perl Compatible Regex in the output of a URL, then parse the received XML for a number that represents a threshold. 
# Returns OK if the expected number is bigger that the received one, CRITICAL otherwise

# help requested or invalid parameters
#############################################################
printhelp () {
	echo "find a Perl compatible Regex in a remote XML based webservice, then extract a number from a field"
	echo ""
	echo "Usage:  check_url_pcre_xml hostname path REGEX field EXPECTED_DIGIT [--http]"
	echo ""
	echo "HTTPS is enabled by default, use --http at the end of the command in order to disable it"
	echo "Example: check_url_pcre_xml www.example.com /statistics.html '.*connected users.*\n.*' users 90"
	exit 3
	}

if [ "$1" == '-h' ] ||  [ "$1" == '--help' ]  || [ -z "$1" ] || [ -z "$2" ]
	then 
	printhelp
fi



#############################################################
# Set to http if specified, default to https
PROTOCOL="https"
if [ "$6" == "--http" ] 
	then
		PROTOCOL="http"
fi

#############################################################
#Run the command

XMLresponse=$(curl --silent "$PROTOCOL://$1$2" | pcregrep -M "$3")

#capture the exit code
LASTEXITCODE=$?

EXPECTEDDIGIT="$5"
RETURNEDDIGIT=$(echo "$XMLresponse" | grep $4 | pcregrep -o ">(\d\d\d|\d\d|\d)<" | pcregrep -o "(\d\d\d|\d\d|\d)")

#return output based on the exit code
#Regex not found, error
if [ "$LASTEXITCODE" != 0 ] 
	then
		echo "CRITICAL - Regular Expression not found in $PROTOCOL://$1$2"
		exit 2
fi

#Regex was found, process it
if [ $RETURNEDDIGIT -le $EXPECTEDDIGIT ]
	then
		echo "$(date) ; OK ; Expected $EXPECTEDDIGIT; returned $RETURNEDDIGIT"
		exit 0
	else
		echo "$(date) ; CRITICAL ; Expected $EXPECTEDDIGIT; returned $RETURNEDDIGIT"
		exit 2
fi
