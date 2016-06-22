#!/bin/bash
language_dir=ca
excepttitle=`cat $language_dir/excepttitle.cfg | tr '\n' '|' | sed -r 's/\|$//' `
exceptinside=`cat $language_dir/exceptinside.cfg  | tr '\n' '|' | sed -r 's/\|$//' `
#echo python core/pwb.py replace.py "\b$1\b" "$2" -search:"\"$1\"" -regex -exceptitle:"$excepttitle" -exceptinside:"$exceptinside" -always -summary:"bot: $1 > $2"
python ~/pywikibot-core/pwb.py replace -ns:0 -search:"\"$1\"" "\b$1\b" "$2" -regex -exceptinsidetag:hyperlink -always -summary:"bot: $1 > $2"

