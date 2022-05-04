#!/bin/bash

# Parsing args
while getopts ":f:o:" opt; do
    case $opt in
        f) file="$OPTARG" ;;
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
        db=$output
    else
        db="$name.db"
    fi 
    
    # Create db
    touch $db

    # Converting CSV to sqlite
    sqlite3 $db ".mode csv"
    sqlite3 $db ".import $file $name"

    echo "Done"
elif [ -z $file ] ; then
    echo "No input file provided"
elif [ ! -e $file ] ; then
    echo "$file does not exist"
fi