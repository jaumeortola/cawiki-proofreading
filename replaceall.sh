#!/bin/bash
LANGUAGE=ca
excepttitle=`cat ~/cawiki-proofreading/${LANGUAGE}/excepttitle.cfg | tr '\n' '|' | sed -r 's/\|$//' `
exceptinside=`cat ~/cawiki-proofreading/${LANGUAGE}/exceptinside.cfg  | tr '\n' '|' | sed -r 's/\|$//'`
#echo python core/pwb.py replace.py "\b$1\b" "$2" -search:"\"$1\"" -regex -exceptitle:"$excepttitle" -exceptinside:"$exceptinside" -always -summary:"bot: $1 > $2"
#python core/pwb.py replace -page:Usuari:Langtoolbot/proves "\b$1\b" "$2" -regex -excepttitle:"$excepttitle" -exceptinside:"$exceptinside" -exceptinsidetag:hyperlink -always -summary:"bot: $1 > $2" -ns:0  -search:"\"$1\""  -page:"Usuari:Langtoolbot/proves"

#echo $exceptinside
#exit 1
if [ "$#" -eq 2 ]; then
    summary=`echo "bot: -$1 +$2"`
    summary="${summary//log/l_g}"
    python3 ~/pywikibot-core/pwb.py replace -ns:0 -search:"insource:\"$1\"" "\b$1\b" "$2" -regex -excepttitle:"$excepttitle" -exceptinside:"$exceptinside" -exceptinsidetag:hyperlink -exceptinsidetag:pre -exceptinsidetag:source -always -summary:"$summary"
fi
if [ "$#" -eq 3 ]; then
    summary=`echo "bot: -$3"`
    python3 ~/pywikibot-core/pwb.py replace -ns:0 -search:"insource:$3" "$1" "$2" -regex -excepttitle:"$excepttitle" -exceptinside:"$exceptinside" -exceptinsidetag:hyperlink -exceptinsidetag:pre -exceptinsidetag:source -always -summary:"$summary"
fi
