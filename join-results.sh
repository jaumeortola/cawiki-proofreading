#!/bin/bash
LANGUAGE=`cat language-code.cfg`
cat ./${LANGUAGE}-dump-data/chunks/*.results > ./${LANGUAGE}-dump-data/results.txt

