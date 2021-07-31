#!/bin/bash

key_input ()        #takes in the key input (i.e. the search word/value) based on the criteria selected
{
    field_index=$(($1+2))
    if [ $field_index -ge 3 ] && [ $field_index -le 9 ]; then
        if [ $field_index == 8 ] || [ $field_index == 9 ]; then
            read -p "Enter the search value (integer): " key
        else
            read -p "Enter the search value (string): " key
        fi
    fi
    echo $key
}

field_sel ()        #this function lets the user select the criteria they want to base the search on
{
    in_file=$1
    filename=$2
    echo -e "\nField Selection:"
    cat "${loglist[0]}" | awk 'BEGIN {FS=","} NR==1 {printf "1. "$3"\n2. "$4"\n3. "$5"\n4. "$6"\n5. "$7"\n6. "$8"\n7. "$9"\n"}'
    read -p "Enter the number of fields to base the search on (either 1, 2 or 3): " num_fields
    num=$num_fields
    until [ $num_fields == 0 ]; do                                  #records key and operator (for number fields, i.e. bytes and packets) for first selection
        if [ $num_fields == 1 ]; then                               #stops if user only chose one criteria
            read -p "Enter field index: " x1
            key1=$(key_input $x1)
            ((num_fields--))
            if [[ $x1 == 6 ]] || [[ $x1 == 7 ]]; then
                intkey+=($key1)
                intkey+=($x1)
                echo -e "\nDo you want your search results to be greater than (>), less than (<), equal to (==) or not equal to (!=) the key value?"
                while true; do
                    read -p "Input your choice ( <, >, ==, != ): " op1
                    if [ $op1 == ">" ] || [ $op1 == "<" ] || [ $op1 == "==" ] || [ $op1 == "!=" ]; then
                        break
                    else   
                        echo "Wrong Input. Please input the correct characters ( <, >, ==, != )."
                        continue
                    fi
                done
            fi
            break
        elif [ $num_fields == 2 ]; then                             #same task as above for the second selection
            read -p "Enter field index: " x2
            key2=$(key_input $x2)
            ((num_fields--))                                        #reduces count of num_fields to go to the first selection
            if [[ $x2 == 6 ]] || [[ $x2 == 7 ]]; then
                intkey+=($key2)
                intkey+=($x2)
                echo -e "\nDo you want your search results to be greater than (>), less than (<), equal to (==) or not equal to (!=) the key value?"
                while true; do
                    read -p "Input your choice ( <, >, ==, != ): " op2
                    if [ $op2 == ">" ] || [ $op2 == "<" ] || [ $op2 == "==" ] || [ $op2 == "!=" ]; then
                        break
                    else   
                        echo "Wrong Input. Please input the correct characters ( <, >, ==, != )."
                        continue
                    fi
                done
            fi
        elif [ $num_fields == 3 ]; then                             #same task as above for third selection
            read -p "Enter field index: " x3
            key3=$(key_input $x3)
            ((num_fields--))
            if [[ $x3 == 6 ]] || [[ $x3 == 7 ]]; then
                echo -e "\nDo you want your search results to be greater than (>), less than (<), equal to (==) or not equal to (!=) the key value?"
                while true; do
                    read -p "Input your choice ( <, >, ==, != ): " op3
                    if [ $op3 == ">" ] || [ $op3 == "<" ] || [ $op3 == "==" ] || [ $op3 == "!=" ]; then
                        break
                    else   
                        echo "Wrong Input. Please input the correct characters ( <, >, ==, != )."
                        continue
                    fi
                done
            fi
        else
            echo -e "\nInvalid input, please retry."
            break
        fi
    done

    y1=$(($x1+2))
    y2=$(($x2+2))
    y3=$(($x3+2))

    echo -e "\nThe search result will be printed below:\n"

    if [ $1 == "all" ]; then                                #loop to get result of all files if user chose to search all of the csv files in the folder
        ftype=".+csv$"
        for file in ./*; do
            if [[ $file =~ $ftype ]]; then
                in_file=$file
                search_engine "$@"
            fi
        done
    else
        search_engine "$@"                                  #else only search inside the one file selected by the user
    fi
    cat $filename | awk 'BEGIN {tot_pack=0; tot_byte=0}
                NR>=1 {
                        tot_pack=tot_pack+$6
                        tot_byte=tot_byte+$7
                    }
                END {printf "Total Packets = "tot_pack"\nTotal Bytes = "tot_byte"\n"}' | tee -a $filename #output the final result
}

search_engine ()                                           #this function does all the searches depending on the user's selections
{
    if [ $num == 1 ]; then
        if [[ $x1 == 6 ]] || [[ $x1 == 7 ]]; then    
            grep "suspicious" $in_file | awk 'BEGIN {FS=","; IGNORECASE=1;}
                NR>1 {
                    if (($'"$y1"' '"$op1"' '"$key1"'))
                        {
                            printf "%-15s %-15s %-15s %-15s %-15s %-15s %-15s \n", $3, $4, $5, $6, $7, $8, $9
                        }
                    }' | tee -a $filename
        else    
            grep "suspicious" $in_file | awk 'BEGIN {FS=","; IGNORECASE=1}
                NR>1 {
                    if (($'"$y1"' ~ /'"$key1"'.*/))
                            printf "%-15s %-15s %-15s %-15s %-15s %-15s %-15s \n", $3, $4, $5, $6, $7, $8, $9
                        }'  | tee -a $filename
        fi
    elif [ $num == 2 ]; then
        if [[ $x1 == 6 ]] || [[ $x1 == 7 ]]; then
            if [[ $x2 == 6 ]] || [[ $x2 == 7 ]]; then        
                grep "suspicious" $in_file | awk 'BEGIN {FS=","; IGNORECASE=1}
                    NR>1 {
                        if (($'"$y1"' '"$op1"' '"$key1"') && ($'"$y2"' '"$op2"' '"$key2"'))
                            { 
                                printf "%-15s %-15s %-15s %-15s %-15s %-15s %-15s \n", $3, $4, $5, $6, $7, $8, $9
                            }
                        }
                    ' | tee -a $filename
            else        
                grep "suspicious" $in_file | awk 'BEGIN {FS=","; IGNORECASE=1}
                    NR>1 {
                        if (($'"$y1"' '"$op1"' '"$key1"') && ($'"$y2"' ~ /'"$key2"'.*/))
                            {
                                printf "%-15s %-15s %-15s %-15s %-15s %-15s %-15s \n", $3, $4, $5, $6, $7, $8, $9
                            }
                        }
                    ' | tee -a $filename
            fi
        else
            if [[ $x2 == 6 ]] || [[ $x2 == 7 ]]; then        
                grep "suspicious" $in_file | awk 'BEGIN {FS=","; IGNORECASE=1}
                    NR>1 {
                        if (($'"$y1"' ~ /'"$key1"'.*/) && ($'"$y2"' '"$op2"' '"$key2"'))
                            {
                                printf "%-15s %-15s %-15s %-15s %-15s %-15s %-15s \n", $3, $4, $5, $6, $7, $8, $9
                            }
                        }
                    ' | tee -a $filename
            else        
                grep "suspicious" $in_file | awk 'BEGIN {FS=","; IGNORECASE=1}
                    NR>1 {
                        if (($'"$y1"' ~ /'"$key1"'.*/) && ($'"$y2"' ~ /'"$key2"'.*/))
                            {
                                printf "%-15s %-15s %-15s %-15s %-15s %-15s %-15s \n", $3, $4, $5, $6, $7, $8, $9
                            }
                        }' | tee -a $filename
            fi
        fi
    elif [ $num == 3 ]; then
        if [[ $x1 == 6 ]] || [[ $x1 == 7 ]]; then
            if [[ $x2 == 6 ]] || [[ $x2 == 7 ]]; then
                if [[ $x3 == 6 ]] || [[ $x3 == 7 ]]; then                
                        grep "suspicious" $in_file | awk 'BEGIN {FS=","; IGNORECASE=1}
                            NR>1 {
                                if (($'"$y1"' '"$op1"' '"$key1"') && ($'"$y2"' '"$op2"' '"$key2"') && ($'"$y3"' '"$op3"' '"$key3"'))
                                    {
                                        printf "%-15s %-15s %-15s %-15s %-15s %-15s %-15s \n", $3, $4, $5, $6, $7, $8, $9
                                    }
                                }
                            ' | tee -a $filename
                else                
                        grep "suspicious" $in_file | awk 'BEGIN {FS=","; IGNORECASE=1}
                            NR>1 {
                                if (($'"$y1"' '"$op1"' '"$key1"') && ($'"$y2"' '"$op2"' '"$key2"') && ($'"$y3"' ~ /'"$key3"'.*/))
                                    {
                                        printf "%-15s %-15s %-15s %-15s %-15s %-15s %-15s \n", $3, $4, $5, $6, $7, $8, $9
                                    }
                                }
                            ' | tee -a $filename
                fi
            else
                if [[ $x3 == 6 ]] || [[ $x3 == 7 ]]; then                
                        grep "suspicious" $in_file | awk 'BEGIN {FS=","; IGNORECASE=1}
                            NR>1 {
                                if (($'"$y1"' '"$op1"' '"$key1"') && ($'"$y3"' '"$op3"' '"$key3"') && ($'"$y2"' ~ /'"$key2"'.*/))
                                    {
                                        printf "%-15s %-15s %-15s %-15s %-15s %-15s %-15s \n", $3, $4, $5, $6, $7, $8, $9
                                    }
                                }
                            ' | tee -a $filename
                else
                
                        grep "suspicious" $in_file | awk 'BEGIN {FS=","; IGNORECASE=1}
                            NR>1 {
                                if (($'"$y1"' '"$op1"' '"$key1"') && ($'"$y2"' ~ /'"$key2"'.*/) && ($'"$y3"' ~ /'"$key3"'.*/))
                                    {
                                        printf "%-15s %-15s %-15s %-15s %-15s %-15s %-15s \n", $3, $4, $5, $6, $7, $8, $9
                                    }
                                }
                            ' | tee -a $filename
                fi
            fi
        else
            if [[ $x2 == 6 ]] || [[ $x2 == 7 ]]; then
                if [[ $x3 == 6 ]] || [[ $x3 == 7 ]]; then                
                        grep "suspicious" $in_file | awk 'BEGIN {FS=","; IGNORECASE=1}
                            NR>1 {
                                if (($'"$y3"' '"$op3"' '"$key3"') && ($'"$y2"' '"$op2"' '"$key2"') && ($'"$y1"' ~ /'"$key1"'.*/))
                                    {
                                        printf "%-15s %-15s %-15s %-15s %-15s %-15s %-15s \n", $3, $4, $5, $6, $7, $8, $9
                                    }
                                }
                            ' | tee -a $filename
                else                
                        grep "suspicious" $in_file | awk 'BEGIN {FS=","; IGNORECASE=1}
                            NR>1 {
                                if (($'"$y2"' '"$op2"' '"$key2"') && ($'"$y1"' ~ /'"$key1"'.*/) && ($'"$y3"' ~ /'"$key3"'.*/))
                                    {
                                        printf "%-15s %-15s %-15s %-15s %-15s %-15s %-15s \n", $3, $4, $5, $6, $7, $8, $9
                                    }
                                }
                            ' | tee -a $filename
                fi
            else
                if [[ $x3 == 6 ]] || [[ $x3 == 7 ]]; then                
                        grep "suspicious" $in_file | awk 'BEGIN {FS=","; IGNORECASE=1}
                            NR>1 {
                                if (($'"$y3"' '"$op3"' '"$key3"') && ($'"$y1"' ~ /'"$key1"'.*/) && ($'"$y2"' ~ /'"$key2"'.*/))
                                    {
                                        printf "%-15s %-15s %-15s %-15s %-15s %-15s %-15s \n", $3, $4, $5, $6, $7, $8, $9
                                    }
                                }
                            ' | tee -a $filename
                else                
                        grep "suspicious" $in_file | awk 'BEGIN {FS=","; IGNORECASE=1}
                            NR>1 {
                                if (($'"$y3"' ~ /'"$key3"'.*/) && ($'"$y1"' ~ /'"$key1"'.*/) && ($'"$y2"' ~ /'"$key2"'.*/))
                                    {
                                        printf "%-15s %-15s %-15s %-15s %-15s %-15s %-15s \n", $3, $4, $5, $6, $7, $8, $9
                                    }
                                }' | tee -a $filename
                fi
            fi
        fi
    fi
}

main ()
{
    read -p "What is the name of the file (with directory): " fil           #records the file name and directory where the user wants to save the file
    dir=$( dirname "$fil")
    mkdir -p "$dir"
    if [ ! -f "$fil" ]; then
        touch $field_sel                                                    #creates the file if its not already existing
    fi
    echo "" > $fil                                                          #cleans out the file if it does exist
    echo "File and directory were created..."
    x=0
    while true; do
        echo -e "List of log files:\n"
        count=0                                                             #lists out all the csv files stored in the directory
        for item in "${loglist[@]}"; do
            ((count++))
            echo -e "$count.\t$item"
        done
        echo -e "\nChoose your option: "
        echo "1. Search all log files"
        echo "2. Search only one log file"
        echo "3. Exit"                                                      #gives user option to search all files, one file, or exit
        read -p "Your choice: " x
        if [ $x == 1 ]; then
            echo -e "You chose to search all files.\n"
            choice="all"
            field_sel $choice $fil
        elif [[ $x == 2 ]]; then
            index=0
            read -p "Enter the index of the log file you want to select: " index        #calls the functions based on the users selection with relevant arguments
            choice="${loglist[$index-1]}"
            echo -e "\nYou chose $choice\n"
            field_sel $choice $fil
        elif [[ $x == 3 ]]; then
            exit 0
        else
            echo -e "Invalid choice, please try again.\n"
        fi
    done
    cat $fil | awk 'BEGIN {tot_pack=0; tot_byte=0}
                            NR>=1 {
                                        tot_pack=tot_pack+$6
                                        tot_byte=tot_byte+$7
                                }
                            END {printf "Total Packets = "tot_pack"\nTotal Bytes = "tot_byte"\n"}' | tee -a $fil

    exit 0
}

declare -a loglist;

ftype=".+csv$"

for file in ./*; do
    if [[ $file =~ $ftype ]]; then                                                      #stores the name of all .csv files in the directory into an array
        loglist+=($(basename $file))
    fi
done
main "$@"                                                                               #calls the main function
