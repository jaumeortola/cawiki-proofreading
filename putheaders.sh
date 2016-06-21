#!/bin/bash
LANGUAGE=`cat language-code.cfg`
files="./${LANGUAGE}-dump-data/chunks/*.xml"
for f in $files
do
    cat ./wikihead.xml $f wikitail.xml > "$f.xml"
    rm $f
    mv "$f.xml" $f
done
