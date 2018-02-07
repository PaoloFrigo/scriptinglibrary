#!/usr/bin/python
""" This script checks if an email address exists on a mailserver. """
__author__ = 'PAOLO FRIGO, paolofrigo@gmail.com | www.scriptinglibrary.com'


import logging
import argparse
from smtplib import SMTP

MAILSERVER = "your.mailserver.com"
PORT = 25
DEBUG_MODE = False

if __name__ == "__main__":

    PARSER = argparse.ArgumentParser(
        description="""DESCRIPTION: This script  checks if an email address
                       exists on a mailserver. """,
        usage="\n./emailchecker.py email@address \
              \n./emailchecker.py -h \t\tfor help",
        epilog="""Author : Paolo Frigo, paolofrigo@gmail.com """)

    PARSER.add_argument('emailaddress', help='email_address')
    PARSER.add_argument('--mailserver', required=False, default=MAILSERVER,
                        help='mailserver address')
    PARSER.add_argument('--port', required=False, default=PORT, type=int,
                        help='port number')
    USERSARGS = PARSER.parse_args()

    logging.basicConfig(level=logging.DEBUG if DEBUG_MODE else logging.ERROR,
                        format='[%(asctime)s][%(levelname)s]: %(message)s')
    logging.info('Email checker script started')

    try:
        with SMTP(host=USERSARGS.mailserver, port=USERSARGS.port) as smtp:
            logging.info('Connecting to {}:{}'.format(USERSARGS.mailserver,
                         USERSARGS.port))
            print(smtp.verify(USERSARGS.emailaddress))
            logging.info('Connection closed ')
    except:
        logging.error("Failed to connect to {}:{}".format(USERSARGS.mailserver,
                                                          USERSARGS.port))
        exit(1)
