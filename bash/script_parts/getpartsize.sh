#!/bin/bash

# (c) JA Vieitez - https://github.com/javieitez/
# Extend the size of the LVM partitions of a VM created from a Debian Template.

# The Template comes with the following LVM partitions
#       * SWAP
#       * /
#       * /var
#       * /var/tmp
#       * /home

# init vars
VGNAME="debian-template-vg"
HDDPARTITION="sda5"
LVM_SWAP="swap_1"
LVM_VAR="var"
LVM_VARTMP="tmp"
LVM_HOME="home"
LVM_ROOT="root"
amiroot=$(sudo whoami)

# get current partition sizes (Output is just a string)
size_ROOT=$(df -h --output=size /dev/$VGNAME/$LVM_ROOT | tr -dc '0-9.GMK')
size_HOME=$(df -h --output=size /dev/$VGNAME/$LVM_HOME | tr -dc '0-9.GMK')
size_VAR=$(df -h --output=size /dev/$VGNAME/$LVM_VAR | tr -dc '0-9.GMK')
size_VARTMP=$(df -h --output=size /dev/$VGNAME/$LVM_VARTMP | tr -dc '0-9.GMK')

parted /dev/sdb print free | grep -iPv "(disk|sector|table)"

echo "Current size of / is $size_ROOT"
echo "Current size of /$LVM_HOME is $size_HOME"
echo "Current size of /$LVM_VAR is $size_VAR"
echo "Current size of /$LVM_VAR/$LVM_VARTMP is $size_VARTMP"
