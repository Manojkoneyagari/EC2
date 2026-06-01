#!/bin/bash

Source_Dir=$1
Days=$(2:-12)


if [ -z $Source_Dir ]; then
 echo " [ ERROR ] This script required an argument: Source Directory"
 exit 1
 fi

 if [ ! -d "$Source_Dir" ]; then
 echo " This Directory $Source_Dir doesn't exists, Provide proper path"
 fi
 
  


 files=$(find "$Source_Dir" -name "*.log" -type f -mtime +$Days)


 echo "Printing log lists $files"

 while read file
 do

 echo  " Log list $file"

 done <<< "$files"