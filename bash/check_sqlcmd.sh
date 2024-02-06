#!/bin/bash

# Quick and dirty script to send a SQL query to an MS SQL DB and parse the output
#
# Author: JA Vieitez https://github.com/javieitez
#
# Requires sqlcmd https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools?view=sql-server-ver16
# 

if [ $1 == '-h' ]
	then
		echo "Usage:  check_sqlcmd.sh -S SERVER -d DATABASE -U USER -P PASSWORD -Q QUERY"
		echo ""
		echo "Example: check_sqlcmd.sh -S 10.10.10.10 -d MYDATABASE -U sa -P 1234 -Q \"SELECT name FROM sys.databases\""
		exit 3
fi

echo "parameters are $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10}" 

# just pass all the parameters
sqlcmd -S $2 -d $4 -U $6 -P $8 -Q "${10}"
#capture the exit code
LASTEXITCODE=$? 

if [ $LASTEXITCODE == 0 ] 
	then
		# Connection successful
		echo "OK - successfully connected to $4"
		exit 0
	else
		echo "CRITICAL - could no connect to $4"
		exit 2
fi

