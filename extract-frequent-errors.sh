#!/bin/bash
LANGUAGE=$LANGUAGE_CODE
rm sentences_extracted.txt
file="./${LANGUAGE}/frequent-errors"
echo "*** Processing file: $file ***"
while read -r i; do
    eval ./extract-sentences.pl $i
done < $file

# >> extract-frequent-errors.log 2>&1
