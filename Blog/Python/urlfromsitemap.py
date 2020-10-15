#!/usr/bin/python
import argparse, logging
import xml.etree.ElementTree as ET

#Paolo Frigo, https://www.scriptinglibrary.com 

parser = argparse.ArgumentParser(
    description='THIS SCRIPTS PRINTS ALL URLs IN THE SITEMAP.XML FILE',
    usage="./urlfromsitemap.py sitemap.xml ", epilog='Author: Paolo Frigo')
        
parser.add_argument('sitemap', default='sitemap.xml', help='sitemap.xml')
args = parser.parse_args()

try: 
    tree = ET.parse(args.sitemap)
    root = tree.getroot()

    for child in root:
        print (child[0].text)

except:
    logging.error("Failed to process " + args.sitemap, exc_info=True)
    exit(1)