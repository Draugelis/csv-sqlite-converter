#!/bin/bash

# Parsing args
while getopts ":f:t:o:" opt; do
    case $opt in
        f) db="$OPTARG" ;;
        t) table="$OPTARG" ;;
        o) output="$OPTARG" ;;
        \?) echo "Invalid option -$OPTARG" >&2
        exit 1 ;;
    esac

    case $OPTARG in
        -*) echo "Option $opt needs a valid argument"
        exit 1 ;;
    esac
done

# Check if input file was provided
if [ -e $file ] ; then 
    # Get db and table name
    name=$(echo $file | grep -o '^[^\.]*')
    if [[ -n $output ]] ; then
        csv=$output
    else
        csv="$name.csv"
    fi 

    # Converting sqlite to csv
    sqlite3 -header $db "SELECT * FROM $table" > $csv

    echo "Done"
elif [ -z $file ] ; then
    echo "No input file provided"
elif [ ! -e $file ] ; then
    echo "$file does not exist"
fi