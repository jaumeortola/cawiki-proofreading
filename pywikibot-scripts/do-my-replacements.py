import pywikibot
import os.path
import re

def isUppercaseFirst(s):
    if len(s)>1:
        return s==(s[0].upper() + s[1:])
    return False

def main(*args):
    local_args = pywikibot.handle_args(args)
    site = pywikibot.Site()
    inputfile = ""
    for arg in local_args:
        if arg.startswith('-file:'):
            inputfile = arg[6:]

    if not os.path.isfile(inputfile):
        pywikibot.error(
            'Input file cannot be read.')
        return False

    with open(inputfile) as f:
        lines = f.readlines()
    
    prog = re.compile("(.*)<\|>(.*)<\|>(.*)<\|>(.*)<\|>(.*)")

    for line in lines:
        line = line.decode('utf-8')
        m = prog.match(line)
        title = m.group(1)
        before = m.group(2)
        tochange = m.group(3)
        after = m.group(4)
        correction = m.group(5)
        aftershort = after
        beforeshort = before
        if len(before)>2:
            beforeshort = before[-3:]
        if len(after)>3:
            aftershort = after[:4]
        try:
            page = pywikibot.Page(site, title)
            text = page.get(get_redirect=True)
        except pywikibot.NoPage:
            pywikibot.output(u'Page %s not found' % page.title(asLink=True))
            continue
        originaltext = text

        wordbefore = ""
        wordafter = ""
        beforelist = before.split()
        afterlist = after.split()
        wordbefore = beforelist[-1]
        wordafter = afterlist[0]
        if before[-1] == " ":
            wordbefore = wordbefore + " "
        if after[0] == " ":
            wordafter = " " + wordafter

        text = originaltext.replace(before + tochange + after, before + correction + after)
        #change if tochange is long
        if text == originaltext and len(tochange)>30:
            text = originaltext.replace(tochange, correction)
        #change tochage+after if it's first uppercase
        if text == originaltext and isUppercaseFirst(tochange):
            text = originaltext.replace(tochange + after, correction + after)
        if text == originaltext:
            text = originaltext.replace(beforeshort + tochange + after, beforeshort + correction + after)
        if text == originaltext:
            text = originaltext.replace(before + tochange + aftershort, before + correction + aftershort)
        if text == originaltext and len(tochange)>2:
            text = originaltext.replace("\n" + tochange + "\n", "\n" + correction + "\n")
        if text == originaltext and len(wordafter)>0:
            text = originaltext.replace(before + tochange + wordafter, before + correction + wordafter)
        if text == originaltext and len(wordbefore)>0:
            text = originaltext.replace(wordbefore + tochange + after, wordbefore + correction + after)
        if text == originaltext and len(wordbefore)>0 and len(wordafter)>0:
            text = originaltext.replace(wordbefore + tochange + wordafter, wordbefore + correction + wordafter)
        if text == originaltext and len(wordbefore)>0:
            text = originaltext.replace(wordbefore + tochange + "\n", wordbefore + correction + "\n")
        if text == originaltext and len(wordafter)>0:
            text = originaltext.replace("\n" + tochange + wordafter, "\n" + correction + wordafter)
        if text != originaltext:
           page.text = text
           summary = u"bot: - " + wordbefore + tochange + wordafter + " + " + wordbefore + correction + wordafter
           page.save(summary)
        else:
           print "No change in page: " + title.encode('utf-8') + " | " + line.encode('utf-8')

if __name__ == "__main__":
    main()
