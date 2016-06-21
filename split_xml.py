import os
import bz2

def split_xml(filename, pages_per_chunk, destination_folder):
    ''' The function gets the filename of wiktionary.xml file as input and creates
    smallers chunks of it in a the diretory chunks
    '''
    # Check and create chunk diretory
    if not os.path.exists(destination_folder):
        os.mkdir(destination_folder)
    # Counters
    pagecount = 0
    filecount = 1
    #open chunkfile in write mode
    chunkname = lambda filecount: os.path.join(destination_folder,filename.replace(".xml","")+str(filecount)+".xml")
    chunkfile = open(chunkname(filecount), 'w')
    # Read line by line
    xmlfile = open(filename)
    inpage = False
    linecount = 0
    pageline = ""
    titleline = ""
    nsline = ""
    redirectline = ""
    idline = ""

    for line in xmlfile:
        if inpage:
            chunkfile.write(line)
        # the </page> determines new wiki page
        if '</page>' in line:
            if inpage:
                pagecount += 1
            inpage = False
            pageline = ""
            titleline = ""
            nsline = ""
            redirectline = ""
            linecount = 0
            idline = ""
        if '<page>' in line:
            pageline = line
            linecount = 1
        if '<title>' in line:
            titleline = line
        if '<ns>' in line:
            nsline = line
        if '<id>' in line:
            idline = line
        if '<redirect' in line:
            redirectline = line
        if (linecount == 5) and ('<ns>0</ns>' in nsline) and (redirectline == ""):
            chunkfile.write(pageline)
            chunkfile.write(titleline)
            chunkfile.write(nsline)
            chunkfile.write(idline)
            chunkfile.write(line)
            inpage = True
        if pagecount > pages_per_chunk:
            #print chunkname() # For Debugging
            chunkfile.close()
            pagecount = 0 # RESET pagecount
            filecount += 1 # increment filename           
            chunkfile = open(chunkname(filecount), 'w')
        linecount += 1
    try:
        chunkfile.close()
    except:
        print 'Files already close'

if __name__ == '__main__':
    # When the script is self run
    split_xml('eswiki-latest-pages-articles.xml', 78812, "es-dump-data/chunks")
