#!/bin/bash
LANGUAGE=ca
wget http://dumps.wikimedia.org/${LANGUAGE}wiki/latest/${LANGUAGE}wiki-latest-pages-articles.xml.bz2
bzip2 -dk ${LANGUAGE}wiki-latest-pages-articles.xml.bz2
