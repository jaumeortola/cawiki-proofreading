#!/bin/bash
LANGUAGE=$LANGUAGE_CODE
wget http://dumps.wikimedia.org/${LANGUAGE}wiki/latest/${LANGUAGE}wiki-latest-pages-articles.xml.bz2
bzip2 -dk ${LANGUAGE}wiki-latest-pages-articles.xml.bz2
mkdir ${LANGUAGE}-dump-data
mv ${LANGUAGE}wiki-latest-pages-articles.* ${LANGUAGE}-dump-data
