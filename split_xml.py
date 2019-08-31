import os
import bz2

def split_xml(filename, maxlines_per_chunk, folder):
    ''' The function gets the filename of wiktionary.xml file as input and creates
    smallers chunks of it in a the diretory chunks
    '''
    # Check and create chunk diretory
    destination_folder = os.path.join (folder, "chunks")
    if not os.path.exists(destination_folder):
        os.mkdir(destination_folder)
    # Counters
    pagecount = 0
    filecount = 1
    #open chunkfile in write mode
    chunkname = lambda filecount: os.path.join(destination_folder,filename.replace(".xml","")+str(filecount)+".xml")
    chunkfile = open(chunkname(filecount), 'w')
    # Read line by line
    xmlfile = open(os.path.join(folder,filename))
    inpage = False
    linecount = 0
    pageline = ""
    titleline = ""
    nsline = ""
    redirectline = ""
    idline = ""
    linesinchunk = 0
    linescopied = 0
    for line in xmlfile:
        if inpage:
            chunkfile.write(line)
            linesinchunk += 1
            linescopied += 1
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
            if linesinchunk > maxlines_per_chunk:
                #print chunkname() # For Debugging
                chunkfile.close()
                linesinchunk = 0
                pagecount = 0 # RESET pagecount
                filecount += 1 # increment filename           
                chunkfile = open(chunkname(filecount), 'w')
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
            linesinchunk += 5
            linescopied += 5
            inpage = True
#        if pagecount > maxlines_per_chunk:
#            #print chunkname() # For Debugging
#            chunkfile.close()
#            linesinchunk = 0
#            pagecount = 0 # RESET pagecount
#            filecount += 1 # increment filename           
#            chunkfile = open(chunkname(filecount), 'w')
        linecount += 1
    print("Total lines copied:", linescopied)
    try:
        chunkfile.close()
    except:
        print 'Files already close'

if __name__ == '__main__':
    # When the script is self run
    split_xml('cawiki-latest-pages-articles.xml', 13000000, "ca-dump-data")
