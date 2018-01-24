#!/usr/bin/python3
# CombineApacheConfig.py 

__author__ = 'ben', 'paolofrigo@gmail.com'
import sys, os, os.path, logging, fnmatch, re, argparse

def ProcessMultipleFiles(InputFiles):
    if InputFiles.endswith('/'):              
        InputFiles = InputFiles + "*"
    Content = ''
    LocalFolder = os.path.dirname(InputFiles)
    basenamePattern = os.path.basename(InputFiles)
    for root, dirs, files in os.walk(LocalFolder):
        for filename in fnmatch.filter(files, basenamePattern):
            Content += ProcessInput(os.path.join(root, filename))
    return Content


def RemoveExcessiveLinebreak(LineOfContent):
    Length = len(LineOfContent)
    LineOfContent = LineOfContent.replace(os.linesep + os.linesep + os.linesep, os.linesep + os.linesep)
    NewLength = len(LineOfContent)
    if NewLength < Length:
        LineOfContent = RemoveExcessiveLinebreak(LineOfContent)
    return LineOfContent


def ProcessInput(InputFile):
    global ServerRoot

    Content = ''
    if logging.root.isEnabledFor(logging.DEBUG):
        Content = '# Start of ' + InputFile + os.linesep
    with open(InputFile, 'r') as infile:
        for line in infile:
            stripline = line.strip(' \t')
            if stripline.startswith('#'):
                continue
            searchroot = re.search(r'ServerRoot\s+(\S+)', stripline, re.I)      #search for ServerRoot
            if searchroot:
                ServerRoot = searchroot.group(1).strip('"')
                logging.info("ServerRoot: " + ServerRoot)
            if stripline.lower().startswith('include'):
                match = stripline.split()
                if len(match) == 2:
                    IncludeFiles = match[1]
                    IncludeFiles = IncludeFiles.strip('"') 
                    if not IncludeFiles.startswith('/'):
                        IncludeFiles = os.path.join(ServerRoot, IncludeFiles)
                    Content += ProcessMultipleFiles(IncludeFiles) + os.linesep
                else:
                    Content += line
            else:
                Content += line
    Content = RemoveExcessiveLinebreak(Content)
    if logging.root.isEnabledFor(logging.DEBUG):
        Content += '# End of ' + InputFile + os.linesep + os.linesep
    return Content

if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG, format='[%(asctime)s][%(levelname)s]:%(message)s')
    parser=argparse.ArgumentParser(
    description="""DESCRIPTION: This script will combine your APACHE httpd.conf with all included files into one.""",
    epilog="""Author :Ben, Paolo Frigo, paolofrigo@gmail.com """)
    parser.add_argument('--apacheconf', required=True, default="/etc/httpd/conf/httpd.conf", help='SPECIFY YOUR FILE PATH.  i.e. /etc/httpd/conf/httpd.conf')
    parser.add_argument('--combinedconf', required=True, default="/tmp/httpd.combined.conf", help='SPECIFY YOUR OUTPUT FILE WITH THE COMBINED CONF FILE. i.e. /tmp/httpd.combined.conf')
    args=parser.parse_args()

    try:
        ServerRoot = os.path.dirname(args.apacheconf)
        Content = ProcessInput(args.apacheconf)
    except Exception as e:
        logging.error("Failed to process " + args.apacheconf,  exc_info=True)
        exit(1)
    try:
        with open(args.combinedconf, 'w') as outfile:
            outfile.write(Content)
    except Exception as e:
        logging.error("Failed to write to " + outfile,  exc_info=True)
        exit(1)

    logging.info("All files have been merged into : " + args.combinedconf)