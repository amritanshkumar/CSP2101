#!/bin/bash

#                                                   TASK 4
#   Write a script that uses awk exclusively to check all user passwords in a text file to ensure they meet the
#   following password strength rules:
#       a. Must be eight (8) or more characters in length
#       b. Must contain at least one (1) number
#       c. Must contain at least one (1) uppercase letter

#Using "awk" exclusively with a few if else statements. First to skip the first line which is the header. Second to check if it passes the conditions for being a valid password
awk '
{
i=0;
if (NR==1)
    {
    i=i+1;
    printf "%s\t%d\n", "Count is ", i;
    next;
    }
else
    if ( length($2)>8 && $2 ~ "[[:upper:]]" && $2 ~ "[[:digit:]]" ) 
        printf "%s\t\t%s\n", $2, " - meets password strength requirements";

    else
        printf "%s\t\t%s\n", $2, " - does NOT meet password strength requirements";

}' usrpwords.txt        #The if else statements output whether the password matches the conditions or not. The file containing the paswords is mentioned at the end of the quotes, so that awk can read the file

exit 0                  #exit after completing the script
