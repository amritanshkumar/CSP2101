#!/bin/bash

#                                                 TASK 1
#   Write a script that calculates the sum of three (3) integers passed to it through the command line and
#   display this to the terminal. If however this sum exceeds 30, give the user a warning indicating this and then
#   exit the script.

sum=$(($1+$2+$3))       #We create a variable that will store the sum of the parameters entered by the user.
if [[ $sum -le 30 ]]    #The if statement checks whether the sum is greater than or less than 30.
then
    echo "The sum of $1 and $2 and $3 is $sum"  #This will be the output if the sum is less than 30.
else
    echo "Sum exceeds maximum allowable"        #This will be the output if the sum is greater than 30.
fi
exit 0      #This line is used to terminate the bash script and return to the terminal. 
