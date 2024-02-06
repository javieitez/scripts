#!/bin/bash

# Determine if the current OS is Debian or Redhat Based

# Init vars
osRELEASE="/etc/os-release"
myOSID="$(cat "$osRELEASE" | grep "^ID=" | cut -c 4-)"
myOSFAMILY="Undetermined"

#Determine OS Family
if [[ $myOSID == "rhel" || $myOSID == "centos" || $myOSID == "ol" ]]
    then
        myOSFAMILY="RedHat"
elif [[ $myOSID == "ubuntu" || $myOSID == "debian" ]]
    then
        myOSFAMILY="Debian"
fi


echo "Your OS is "$myOSID", as stated on "$osRELEASE""
echo ""$myOSID" belongs to the "$myOSFAMILY" family"

