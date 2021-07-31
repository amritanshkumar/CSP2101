#!/bin/bash

#                                                     TASK 3
#   Write a script that uses grep, sed and awk in combination to extract specific information from a .html file
#   and echo it to the terminal as a formatted summary. Use piping to reduce number of lines of code.
#
#   Sample Output:
#     Attacks		  Instances(Q3)
#     DDOS		    1562
#     MALWARE		  1004
#     XSS		      1328
#     SQL-INJ		  792
#     MitM		    327

#I used the "cat" command with piping to reduce the number of lines of the code #using grep I get the lines I need which are the ones with the attacks and their frequencies
#I used 'sed' command to make omit these parts from the final result.
cat attacks.html | grep "<td>" | sed -e "s/<tr><td>/ /g; s/<\/td><td>/ /g; s/<\/td><tr>/ /g" | awk 'BEGIN {print"Attacks\t\tInstances(Q3)"} {if (NR==0) {next;} sum = $2 + $3 + $4; printf "%s\t\t%d\n", $1, sum;}' 
#I used "awk" command with different conditions to finally display the required result in the correct format
exit 0      #exit after completing the script
