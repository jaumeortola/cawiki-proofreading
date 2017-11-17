#!/bin/bash
LANGUAGE=ca
for file in /home/jortola/cawiki-proofreading/${LANGUAGE}/*.txt
do
    echo "*** Processing file: $file ***"
    while read -r i; do
	echo "*** Searching: $i ***"
	eval /home/jortola/cawiki-proofreading/replaceall.sh $i
    done < $file
done

