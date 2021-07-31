#!/bin/bash
#Task 4
#Name           : Amritansh Kumar
#Student Number : 10547319

choice=0                    #establish a choice variable
while [[ $choice != 4 ]]    #loop to repeat until the user chooses to exit
do
    echo -e "\nChoose your option for the pattern search (key in the option number)-"   #
    echo "1. Full word search."                                                         #   present user with
    echo "2. Any match with the keyword."                                               #   basic choices
    echo "3. Inverted search (i.e. retrieve lines that do not contain the keyword)."    #
    echo -e "4. EXIT.\n"                                                                #
    read -p "Enter your choice here: " choice       #input choice 

    if [[ $choice == 4 ]]       #if user chooses to exit, we return to the terminal immediately
    then
        exit 0
    fi

    echo ""
    read -p "Enter the term you need to search: " key               #get the keyword to search from the user
    echo -e "\nYou can find the results of your search below:\n"
    
    if [[ $choice == 1 ]]       #choice 1 is whole word search
    then
        grep -i -w -n $key access_log.txt       # '-w' searches for the whole word, '-n' gives output with line numbers, and '-i' makes it case-insensitive
        countl="$(grep -c -i -w $key access_log.txt)"       # '-c' counts instead of outputing the matching lines
        countw="$(grep -i -w -o $key access_log.txt | wc -l)"       # '-o' is used for the number occurences
        echo -e "\nThe number of lines containing the matched term is: $countl\nThe number of times the term matched in these lines is: $countw\n"
    elif [[ $choice == 2 ]]     #choice 2 is any match
    then
        grep -i -n $key access_log.txt                          #
        countl="$(grep -c -i $key access_log.txt)"              # we remove '-w' so all the matches can outputed, regardless if its the whole word or just a part
        countw="$(grep -i -o $key access_log.txt | wc -l)"      #
        echo -e "\nThe number of lines containing the matched term is: $countl\nThe number of times the term matched in these lines is: $countw\n"
    elif [[ $choice == 3 ]]     ##choice 2 is inverted match
    then
        grep -i -v -n $key access_log.txt                       #
        countl="$(grep -c -v -i $key access_log.txt)"           # '-v' is used to get the inverted match results (i.e. show everything except the matches)
        countw="$(grep -i -v -o $key access_log.txt | wc -l)"   #
        echo -e "\nThe number of lines not containing the matched term is: $countl\nThe number of times the term matched in these lines is: $countw\n"
    else
        echo -e "\nInvalid input.\n"
    fi
    
    read -p "Input \"Y\" if you want to quit. Otherwise press \"Enter\" to continue: " cont     #asks user if they wish to retry or exit out of the code
    if [[ $cont == "y" ]] || [[ $cont == "Y" ]]
    then
        exit 0
    fi
done
exit 0