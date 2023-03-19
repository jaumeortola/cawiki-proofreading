#!/bin/bash
PYTHONPATH="${PYTHONPATH}:~/pywikibot-core/pywikibot:/mnt/nfs/labstore-secondary-tools-home/jortola/python3-libs/usr/local/lib/python3.5/dist-packages"
export PYTHONPATH
LANGUAGE=ca
for file in /home/jortola/cawiki-proofreading/${LANGUAGE}/*.txt
do
    echo "*** Processing file: $file ***"
    while read -r i; do
	echo "*** Searching: $i ***"
	eval /home/jortola/cawiki-proofreading/replaceall.sh $i
    done < $file
done

