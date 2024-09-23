#!/bin/bash

print_diff=false
write=false
count=0

for var in "$@"
do
    if [[ $var == "--print-diff" ]]; then
        print_diff=true
    elif [[ $var == "--write" ]]; then
        write=true
    fi
done

for file in $(find . -name '*.tex'); do
    echo -n "Formatting file: $file"
    latexindent -g /dev/stdout -l latexindent.yaml $file > "${file%.tex}_formatted.tex"
    num_changes=$(diff -U0 $file "${file%.tex}_formatted.tex" | grep -v ^@ | wc -l | tr -d '\n')
    if [ "$write" = true ]; then
        echo " ($num_changes changes)"
    else
        echo " ($num_changes problems)"
    fi
    if [ "$print_diff" = true ] && [ "$num_changes" -ne 0 ]; then
        diff -u --color=always $file "${file%.tex}_formatted.tex" | sed -r 's/^/  /'
    fi
    if [ "$write" = true ] && [ "$num_changes" -ne 0 ]; then
        mv "${file%.tex}_formatted.tex" $file
    else
        rm "${file%.tex}_formatted.tex"
    fi
    if [ "$num_changes" -ne 0 ]; then
        ((count++))
    fi
done

if [ "$write" = true ]; then
    echo "Number of files with changes: $count"
else
    echo "Number of files with problems: $count"
fi

