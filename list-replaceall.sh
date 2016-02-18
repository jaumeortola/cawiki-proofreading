#!/bin/bash
language_dir=ca
for file in $language_dir/*.txt
do
    echo "*** Processing file: $file ***"
    while read -r i; do
	echo "*** Searching: $i ***"
	eval ./replaceall.sh $i
    done < $file
done

