#!/bin/bash
LANGUAGE=$LANGUAGE_CODE
cat ./${LANGUAGE}-dump-data/chunks/*.results > ./${LANGUAGE}-dump-data/results.txt

