#!/bin/bash

#                                 TASK 2
#   Write a script that retrieves the following information about a file:
#     a. Its size in kilobytes
#     b. The number of words it contains
#     c. The date/time it was last modified

getprop() {                                                                                     #define the getprop function first so that it can be called back to later in the script
    file_size=$( awk "BEGIN {printf \"%.2f\",$(stat -c%s "$1")/1024}" )                         #I used "stat -c%s" to get the size of the file in bytes, which when divided by 1000 is size in kilobytes. I had to use "awk" to represent the size in float form.
    word_count="$( wc -w < "$1" )"                                                              #I used the "wc" with "-w" option to count the number of words in the file and store in the variable
    mod_date_epoch=$( stat -c%Y "$1" )                                                          #I used the "stat -c%Y" to store the last modified time of the file in epoch seconds form
    last_modified_date=$( date -d "1970-01-01 UTC $mod_date_epoch seconds" +"%d-%m-%Y %T" )     #I reused the variable from the previous line and converted it into date time in the required format as mentioned in the assignment instructions using the date function
    echo "The file" $1 "contains" $word_count "words and is" $file_size"K in size and was last modified" $last_modified_date
}                                                                                               #output the required results^

read -p "Enter the name of the file of which you want the information of: " file_name           #get the name of the file from the user and store it in the "file_name" variable
getprop $file_name                                                                              #call the "getprop" function with the "file_name" variable as the argument
exit 0                                                                                          #exit after completing the script
