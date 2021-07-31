#!/bin/bash

#                                                 TASK 2
#   Write a script that when run, prompts the user to enter a two digit numeric code (integer) that is either
#   equal to 20 or equal to 40.

read -p "Enter the code: " x        #ask user to input the code

while [[ $x != 40 ]] && [[ $x != 20 ]];do       #starts loop to repeat until the correct code isn't entered (i.e. 20 or 40)
    if ! [[ "$x" =~ ^[0-9]+$ ]]                 #checks whether the input is not an integer
    then
        echo "The code you entered is invalid."                             #if the input code wasnt an integer this message will be echoed
        read -p "Please re-enter a valid code that is an integer: " x       #and the user will be asked to re-enter the correct code
    else                                        #if the code entered was an integer but wasn't the correct code (20 or 40), the code below will be executed
        read -p "Entered code is wrong. Please retry: " x                   #asking the user to retry
    fi
done                    #the loop will end when the correct code is entered

if [[ $x == 40 ]] || [[ $x == 20 ]]         #just to make sure that the correct code was entered this if statement checks if the the value of 'x' is 20 or 40
    then
        echo "Success!"     #if it is then the success message will be echoed
    fi

exit 0
