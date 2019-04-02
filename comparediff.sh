#!/bin/bash

# Author: JA Vieitez

if [ $1 == "-h" ] || [ $1 == "--help" ]
	then
		echo "USAGE: comparediff fileA fileB outputfile"
		echo "compares the content of fileA, line by line, with the content of fileB, and writes the output to outputfile"
		exit 0
fi

for i in $(cat $1); do
    grep $i $2
	LASTEXITCODE=$? 
	if [ $LASTEXITCODE == 0 ] 
	then
		# line exists in file B
		echo "$i exists in $2"
	else
		echo "$i" >> $3
fi
done
