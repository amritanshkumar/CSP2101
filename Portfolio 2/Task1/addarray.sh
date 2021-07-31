#!/bin/bash

        #                                         TASK 1
        # Write a script that employs a c-style loop to calculate the sum of two assignment scores as they appear
        # ordinarily in separate arrays. The arrays are as follows:
        # First Array 12 18 20 10 12 16 15 19 8 11
        # Second Array 22 29 30 20 18 24 25 26 29 30
        # For example, the first two assignment scores to be added would be 12 and 22.
        # The output to the screen of the results should be as follows:
        # Student_1 Result: xx
        # Student_2 Result: xx
        # Student_3 Result: xx
        # Student_4 Result: xx
        # Student_5 Result: xx
        # Student_6 Result: xx
        # Student_7 Result: xx
        # Student_8 Result: xx
        # Student_9 Result: xx
        # Student_10 Result: xx
        # …where xx represents the sum of the two corresponding assignment scores in each array.


declare -a ass1=(12 18 20 10 12 16 15 19 8 11)              #declare first array and set values as given in assignment instrucions
declare -a ass2=(22 29 30 20 18 24 25 26 29 30)             #declare second array and set values as given in assignment instrucions
declare -a result=()                                        #declare the array that will store the results
len=${#ass1[@]}                                             #calculate and store the length of the array to be used in the for loop

for (( i=0; i<$len; i++ ))                                  #start c-style for loop which increments until it finishes going through all the values in the array
    do
    result[$i]=$(( ${ass1[$i]}+${ass2[$i]} ))               #store the sum of ass1[i] and ass2[i] in the result[i] array
    echo -e "Student_"$(( $i+1 ))" Result:\t"${result[$i]}  #echo out the result with the student number and the sum of their marks in ass1 ans ass2 stored in result
    done
exit 0        #exit after completing the script
