#!/bin/bash
while read -r line
do
    ./extract-sentences-rule.pl $line &
done < "rules-to-extract.txt"
