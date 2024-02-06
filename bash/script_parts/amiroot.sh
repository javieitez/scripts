#!/bin/bash


if [ "$(whoami)" != "root" ]
then
  echo "This script must be executed with root privileges"
  exit
else
echo "you are root..."
fi