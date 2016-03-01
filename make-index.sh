#!/bin/bash
ltwiki_java_dir=~/languagetool/languagetool-wikipedia/target/LanguageTool-wikipedia-3.3-SNAPSHOT/LanguageTool-wikipedia-3.3-SNAPSHOT
java -jar ${ltwiki_java_dir}/languagetool-wikipedia.jar index-data cawiki-latest-pages-articles.xml index-dir ca 0
