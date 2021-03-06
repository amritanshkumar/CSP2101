#!/bin/bash

#                                                     TASK 3
#   Write a script that counts the number of files and child directories within a specified directory according to a
#   specified property.


countfil=0              #   establish
countempfil=0           #   the count
countdir=0              #   variables
countempdir=0           
read -p "Please enter the directory of which you need the counts: " dir         #ask the user to enter the directory of which they need the count for
for item in $dir/*      #this for loop goes repeats until it goes through every item in the directory
do
    [[ -f "$item" ]] && [[ -s "$item" ]] && { (( countfil ++ )); }                  #checks whether said item is a file and is not empty, if true, increase count
    [[ -f "$item" ]] && [[ ! -s "$item" ]] && { (( countempfil ++ )); }             #checks whether said item is a file and is empty, if true, increase count
    [[ -d "$item" ]] && [[ "$(ls -A $item)" ]] && { (( countdir ++ )); }            #checks whether said item is a directory and is not empty (by listing ls), if true, increase count
    [[ -d "$item" ]] && [[ ! "$(ls -A $item)" ]] && { (( countempdir ++ )); }       #checks whether said item is a directory and is empty (by listing ls), if true, increase count
done

echo "The $dir directory contains:"             #
echo $countfil " files that contain data"       #       echo the results
echo $countempfil " files that are empty"       #           of all
echo $countdir " non-empty directories"         #     the counts calculated
echo $countempdir " empty directories"          #            above

exit 0
