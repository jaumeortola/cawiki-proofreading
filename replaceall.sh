#!/bin/bash
language_dir=ca
excepttitle=`cat $language_dir/excepttitle.cfg`
exceptinside=`cat $language_dir/exceptinside.cfg`
#echo python core/pwb.py replace.py "\b$1\b" "$2" -search:"\"$1\"" -regex -exceptitle:"$excepttitle" -exceptinside:"$exceptinside" -always -summary:"Corregit: $1 > $2"
#python core/pwb.py replace -page:Usuari:Langtoolbot/proves "\b$1\b" "$2" -regex -excepttitle:"$excepttitle" -exceptinside:"$exceptinside" -exceptinsidetag:hyperlink -always -summary:"Corregit: $1 > $2" -ns:0  -search:"\"$1\""  -page:"Usuari:Langtoolbot/proves"
if [ "$#" -eq 2 ]; then
    summary=`echo "Corregit: -$1 +$2"`
    summary="${summary//log/l_g}"
    python core/pwb.py replace -ns:0 -search:"\"$1\"" "\b$1\b" "$2" -regex -excepttitle:"$excepttitle" -exceptinside:"$exceptinside" -exceptinsidetag:hyperlink -always -summary:"$summary"
fi
if [ "$#" -eq 3 ]; then
    summary=`echo "Corregit: -$3"`
    python core/pwb.py replace -ns:0 -search:"$3" "$1" "$2" -regex -excepttitle:"$excepttitle" -exceptinside:"$exceptinside" -exceptinsidetag:hyperlink -always -summary:"$summary"
fi
