#!/bin/bash
#ltwiki_java_dir=~/languagetool/languagetool-wikipedia/target/LanguageTool-wikipedia-3.3-SNAPSHOT/LanguageTool-wikipedia-3.3-SNAPSHOT
ltwiki_java_dir=~/LanguageTool-wikipedia-3.4-SNAPSHOT
cd dump-data-new
java -jar ${ltwiki_java_dir}/languagetool-wikipedia.jar check-data --file cawiki-latest-pages-articles.xml --language ca > analysis-results.txt 2>analysis-errors.txt &

