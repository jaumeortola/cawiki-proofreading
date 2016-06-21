#!/bin/bash
LANGUAGE=`cat language-code.cfg`
for file in ${LANGUAGE}/*.txt
do
    echo "*** Processing file: $file ***"
    while read -r i; do
	echo "*** Searching: $i ***"
	eval ./replaceall.sh $i
    done < $file
done

