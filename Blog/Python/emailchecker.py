#!/usr/bin/python
""" This script checks if an email address exists on a mailserver. """

__author__ = "PAOLO FRIGO | https://www.scriptinglibrary.com"

import logging
import argparse
from smtplib import SMTP

MAILSERVER = "your.mailserver.com"
PORT = 25
DEBUG_MODE = False
RFC_LINK = r"https://goo.gl/9hYJQg"

if __name__ == "__main__":

    PARSER = argparse.ArgumentParser(
        description="""DESCRIPTION: This script  checks if an email address
                       exists on a mailserver. """,
        usage="\n./emailchecker.py email@address \
              \n./emailchecker.py -h \t\tfor help",
        epilog="""Author : Paolo Frigo""",
    )

    PARSER.add_argument("emailaddress", help="email_address")
    PARSER.add_argument(
        "--mailserver", required=False, default=MAILSERVER, help="mailserver address"
    )
    PARSER.add_argument(
        "--port", required=False, default=PORT, type=int, help="port number"
    )
    USERSARGS = PARSER.parse_args()

    logging.basicConfig(
        level=logging.DEBUG if DEBUG_MODE else logging.ERROR,
        format="[%(asctime)s][%(levelname)s]: %(message)s",
    )
    logging.info("Email checker script started")

    try:
        with SMTP(host=USERSARGS.mailserver, port=USERSARGS.port) as smtp:
            logging.info(
                "Connecting to {}:{}".format(USERSARGS.mailserver, USERSARGS.port)
            )
            result = smtp.verify(USERSARGS.emailaddress)
            print("SMTP CODE: {} \nMESSAGE: {}".format(*result))
            logging.info("RFC1893, SMTP CODES: {}".format(RFC_LINK))
            logging.info("Connection closed ")
    except:
        logging.error(
            "Failed to connect to {}:{}".format(USERSARGS.mailserver, USERSARGS.port)
        )
