#!/bin/bash
LANGUAGE=$LANGUAGE_CODE
ltwiki_java_dir=~/lt-wiki
dumpdir=./${LANGUAGE}-dump-data/chunks/
for file in "$dumpdir"${LANGUAGE}wiki-*.xml
do
    java -Xms512m -Xmx2048m -jar ${ltwiki_java_dir}/languagetool-wikipedia.jar check-data --file "$file" --rule-properties ./rules.cfg --language ${LANGUAGE} > "$file.results" 2>"$file.log" &
done

