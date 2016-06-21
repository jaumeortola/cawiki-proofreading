## Requirements & setup
This project includes several tools that can be used separately.
* The scripts are written mostly in Python using [Pywikibot](https://www.mediawiki.org/wiki/Manual:Pywikibot). Scripts in the folder /pywikibot-scripts should be copied in the approriate pywikibot-core/scripts folder.
* There are some scripts in Perl that use the [MediaWiki::Bot](http://search.cpan.org/~lifeguard/MediaWiki-Bot-5.006002/lib/MediaWiki/Bot.pm) framework.
* Scripts in bash. 
* The linguistic anaylsis is made with [LanguageTool](https://languagetool.org/) which requires Java 8.

<!--## Simple replacements-->

## Errors that can be corrected always automatically 
`list-replaceall.sh` makes all the replacements. **Important**: You must be absolutely sure that it is always fine to apply the correction. This implies that you don't change words in other languages (in Catalan, we have to take care specially of words in Spanish, Portuguese, French and Italian) or in non-standard language (old or dialectal).
* Lists of replacements are inside a folder (/ca for Catalan) in .txt files. Every line is a substitution and every line can contain two or three parameters. With two arguments (i.e. `"requeriment tècnic" "requisit tècnic"`) every ocurrence of the first argument will be replaced by the second in every article in the Wikipedia. Word boundaries (\b) are assumed. With 3 arguments (i.e. `"\b([Aa]nal)·l(itz.+)\b" "\1\2" "anal·litzar"`) every ocurrence of the first argument (as a regular expression) is replaced by de second argument. The third argument is the string to be searched. Word boundaries are not assumed.
* The file excepttitle.cfg contains titles of articles to be ignored always. The file exceptinside.cfg contains names of templates or tags where the replacements should not be done. 

## Extract sentences, supervise and apply changes

* Extract sentences with `./extrat-sentences.pl "fins el" "fins al"`. First argument is the string to search for. Second argument is the correction
* A text file named `sentences_extracted.txt` is generated with this structure:
```
.................original sentence..........<|>Article title<|>wrong string<|>correct string
.................corrected sentence.........<|>(y)es/(n)o/(d)iscard
```

For example:
```
des de Saragossa fins el Delta, que no es va arribar a fer.<|>Club Muntanyenc l'Hospitalet<|>fins el<|>fins al
des de Saragossa fins al Delta, que no es va arribar a fer.<|>y

nça va continuar fins el 1659, data en què es va signar la <|>Història de Barcelona<|>fins el<|>fins al
nça va continuar fins al 1659, data en què es va signar la <|>y
```

The second line (the corrected sentence) can be edited as desired. The letter at the end of the second line (y/n/d) means:

1. (y)es: the change is to be applied.
2. (n)o: do not apply the change.
3. (d)iscard: do not apply the change and do not extract ever again this sentence. The sentece will be stored in the file `whitelist-extracted-sentences`.

* Run `./prepare-bot.pl`, which generates a file `bot.txt` and adds sentences to `whitelist-extracted-sentences`.
* Run `./do-my-replacements.sh`, which does the actual edits in the Wikipedia articles.

## Frequent errors that need supervision

The sambe process described in the previous section, can be used with a list of usual errors. 
* Write the errors in `frequent-errors`, one per line. 
* Run `./extract-frequent-errors.sh`.
* Edit `sentences_extracted.txt`.
* Run `./prepare-bot.pl` and `./do-my-replacements.sh`.

## Fixing errors with LanguageTool

### Analysis of the Wikimedia dump with LanguageTool
### Extracting and sorting errors
### Supervising errors
### Appliying the corrections
