#!/usr/bin/python
""" This script combines your APACHE httpd.conf with all included files\
   into one and redirects it to the standard output. """
__author__ = "ben", "PAOLO FRIGO | www.scriptinglibrary.com"

import os
import os.path
import logging
import fnmatch
import re
import argparse

def ProcessMultipleFiles(inputfiles):
    """ Process an expression with /* with all the files included on that directory """
    if inputfiles.endswith("/"):
        inputfiles = inputfiles + "*"
    content = ""
    localfolder = os.path.dirname(inputfiles)
    basenamepattern = os.path.basename(inputfiles)
    for root, dirs, files in os.walk(localfolder):
        for filename in fnmatch.filter(files, basenamepattern):
            content += ProcessInput(os.path.join(root, filename))
    return content


def RemoveExcessiveLinebreak(lineofcontent):
    """ Remove Excessive Linebreaks form the line of content passed as argument """
    length = len(lineofcontent)
    lineofcontent = lineofcontent.replace(
        os.linesep + os.linesep + os.linesep, os.linesep + os.linesep
    )
    newlength = len(lineofcontent)
    if newlength < length:
        lineofcontent = RemoveExcessiveLinebreak(lineofcontent)
    return lineofcontent


def ProcessInput(inputfile):
    """ This function accepts an input path for the httpd conf file, searchs
        for 'include' and replaces it with the matchin content of the included
        file, add starts and end comments and removes all other comments or
        spaces. """
    content = ""
    if logging.root.isEnabledFor(logging.DEBUG):
        content = "# Start of " + inputfile + os.linesep
    with open(inputfile, "r") as infile:
        for line in infile:
            stripline = line.strip(" \t")
            if stripline.startswith("#"):
                continue
            # search for serverroot
            searchroot = re.search(r"serverroot\s+(\S+)", stripline, re.I)
            if searchroot:
                serverroot = searchroot.group(1).strip('"')
                logging.info("serverroot: " + serverroot)
            if stripline.lower().startswith("include"):
                match = stripline.split()
                if len(match) == 2:
                    includefiles = match[1]
                    includefiles = includefiles.strip('"')
                    if not includefiles.startswith("/"):
                        includefiles = os.path.join(serverroot, includefiles)
                    content += ProcessMultipleFiles(includefiles) + os.linesep
                else:
                    content += line
            else:
                content += line
    content = RemoveExcessiveLinebreak(content)
    if logging.root.isEnabledFor(logging.DEBUG):
        content += "# End of " + inputfile + os.linesep + os.linesep
    return content


if __name__ == "__main__":
    logging.basicConfig(
        level=logging.DEBUG, format="[%(asctime)s][%(levelname)s]:%(message)s"
    )
    PARSER = argparse.ArgumentParser(
        description="""DESCRIPTION: This script combines your APACHE httpd.conf with
                    all included files into one and redirects it to the standard output.""",
        usage="./combineapacheconfig.py /etc/httpd/conf/httpd.conf \
              ./combineapacheconfig.py -h  ",
        epilog="""Author :Ben, Paolo Frigo""",
    )
    PARSER.add_argument(
        "apacheconf",
        default="/etc/httpd/conf/httpd.conf",
        help="SPECIFY YOUR HTTPD/APACHE CONF FILE PATH. \
                            i.e. /etc/httpd/conf/httpd.conf",
    )
    USERSARGS = PARSER.parse_args()
    try:
        serverroot = os.path.dirname(USERSARGS.apacheconf)
        content = ProcessInput(USERSARGS.apacheconf)
    except Exception as e:
        logging.error("Failed to process " + USERSARGS.apacheconf, exc_info=True)
        exit(1)
    print(content)
