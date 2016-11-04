#!/bin/bash
IFS_BACKUP=$IFS
IFS=$'\n'

file_name=$1
file_length=0
maxline=`wc -l ${1}`
maxline=${maxline% *}

cat ${file_name} | while read line
do

    length=${#line}
    for (( i = 0; i < length; i++ )); do

        char=${line:i:1}
        char_tab=${char%	}
        if  [[ $char != $char_tab ]]; then
            tab_line=`expr $file_length + 1`
            echo "${tab_line}line ${i}column Tab"
        fi

    done

    (( file_length++ ))

    line_space=${line% }
    if [[ $line != $line_space ]]; then
        echo "end of ${file_length}line space"
    fi

    if [[ $file_length = $maxline ]] && [[ $length = 0 ]]; then
        echo "final newline"
    fi

done

IFS=$IFS_BACKUP

exit 0
