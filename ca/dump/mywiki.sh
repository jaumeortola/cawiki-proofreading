#!/bin/bash
jardir=/home/jaume/github/languagetool/languagetool-wikipedia/target/LanguageTool-wikipedia-2.5-SNAPSHOT/LanguageTool-wikipedia-2.5-SNAPSHOT
#dumpdir=/home/ec2-user/wikidump/chunks
#jardir=~/lt
dumpdir=~/languagetool_work/wikidump/dump/
for file in "$dumpdir"cawiki-2014*.xml
do
    java -jar "$jardir/languagetool-wikipedia.jar" check-dump -f "$file" -l ca > "$file.results" 2>>wikidump.log &
done

