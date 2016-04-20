#!/bin/bash
ltwiki_java_dir=~/lt-wiki
dumpdir=./dump-data/chunks/
for file in "$dumpdir"cawiki-*.xml
do
    java -jar ${ltwiki_java_dir}/languagetool-wikipedia.jar check-data --file "$file" --language ca > "$file.results" 2>"$file.log" &
done

