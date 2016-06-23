## Requirements & setup
This project includes several tools that can be used separately.
* The scripts are written mostly in Python using [Pywikibot](https://www.mediawiki.org/wiki/Manual:Pywikibot). Scripts in the folder /pywikibot-scripts should be copied in the appropriate pywikibot-core/scripts folder.
* There are some scripts in Perl that use the [MediaWiki::Bot](http://search.cpan.org/~lifeguard/MediaWiki-Bot-5.006002/lib/MediaWiki/Bot.pm) framework.
* Scripts in bash. 
* The linguistic analysis is made with [LanguageTool](https://languagetool.org/) which requires Java 8. (At the moment, using a [fork](https://github.com/jaumeortola/languagetool/tree/wiki-proofreading-2) of LanguageTool).
* In the file `language-code.cfg` write the two-letter code for the language you want to work in (i.e. `ca` for Catalan, `fr` for French). Language-dependent data will be stored in a folder named with this code.

<!--## Simple replacements-->

## Errors that can be corrected always automatically 
`list-replaceall.sh` makes all the replacements. **Important**: You must be absolutely sure that it is always fine to apply the correction. This implies that you don't change words in other languages (in Catalan, we have to take care specially of words in Spanish, Portuguese, French and Italian) or in non-standard language (old or dialectal).
* Lists of replacements are inside a folder (/ca for Catalan) in .txt files. Every line is a substitution and every line can contain two or three parameters. With two arguments (i.e. `"requeriment tècnic" "requisit tècnic"`) every occurrence of the first argument will be replaced by the second in every article in the Wikipedia. Word boundaries (\b) are assumed. With 3 arguments (i.e. `"\b([Aa]nal)·l(itz.+)\b" "\1\2" "anal·litzar"`) every occurrence of the first argument (as a regular expression) is replaced by de second argument. The third argument is the string to be searched. Word boundaries are not assumed.
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
3. (d)iscard: do not apply the change and do not extract ever again this sentence. The sentence will be stored in the file `whitelist-extracted-sentences`.

* Run `./prepare-bot.pl`, which generates a file `bot.txt` and adds sentences to `whitelist-extracted-sentences`.
* Run `./do-my-replacements.sh`, which does the actual edits in the Wikipedia articles.

## Frequent errors that need supervision

The same process described in the previous section, can be used with a list of usual errors. 
* Write the errors in `frequent-errors`, one per line. 
* Run `./extract-frequent-errors.sh`.
* Edit `sentences_extracted.txt`.
* Run `./prepare-bot.pl` and `./do-my-replacements.sh`.

## Using LanguageTool

### Analysis of the Wikipedia dump with LanguageTool (LT)
* Download and decompress the latest Wikipedia dump with `./download-latest-dump.sh`.
* Currently LT is not fully optimized for multithreading. As a rule of thumb, we split the dump file in the number of available CPUs, using `split.py`. 
* Add headers to the chunks with `./putheaders.sh`.
* Analyze the chunks with LT. Execute: `./chunks-analyze.sh`. This process can take hours or days depending on the size of the Wikipedia and the computing power available.
* Join the results in a single file. Execute: `./join-results.sh`.
* Get a results summary with `./get-results-summary.pl`.

### Extract sentences by rule, supervise and apply changes 

This process is similar to that described above. But now we are going to extract the errors from the results of the LT analysis. 
* Extract the errors by rule. For example, for errors with id="SON": `./extract-sentences-rule.pl SON`.
* Edit `sentences_SON.txt`.
* Run `./prepare-bot.pl SON`.
* Apply the changes with `./do-my-replacements.sh`.
 
