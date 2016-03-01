#!/bin/bash
language_dir=ca
excepttitle=`cat $language_dir/excepttitle.cfg`
exceptinside=`cat $language_dir/exceptinside.cfg`
#echo python core/pwb.py replace.py "\b$1\b" "$2" -search:"\"$1\"" -regex -exceptitle:"$excepttitle" -exceptinside:"$exceptinside" -always -summary:"Corregit: $1 > $2"
python ~/pywikibot-core/pwb.py replace -ns:0 -search:"\"$1\"" "\b$1\b" "$2" -regex -exceptinsidetag:hyperlink -always -summary:"Corregit: $1 > $2"

