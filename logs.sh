#!/bin/bash

Source_Dir=$1
Days=${2:-12}


if [ -z $Source_Dir ]; then
 echo " [ ERROR ] This script required an argument: Source Directory"
 exit 1
 fi

 if [ ! -d "$Source_Dir" ]; then
 echo " This Directory $Source_Dir doesn't exists, Provide proper path"
 exit 1
 fi
 
  
files=$(find "$Source_Dir" -name "*.log" -type f -mtime +$Days)

if [ -z "$files" ]; then
echo " We dont have log files exits older then 12 days ago"
exit 0
fi


 while IFS= read -r file
 do

 echo  "$file"

 done <<< "$files"