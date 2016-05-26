#!/bin/bash
language_dir=ca
rm sentences_extracted.txt
file="./ca/frequent-errors"
echo "*** Processing file: $file ***"
while read -r i; do
    eval ./extract-sentences.pl $i
done < $file

# >> extract-frequent-errors.log 2>&1
