#!/bin/bash

# Paolo Frigo, https://www.scriptinglibrary.com
# This script creates a local copy of a  website using WGET

read -p 'URL: ' URL
wget --verbose --debug --adjust-extension --backup-converted --base=$URL --no-http-keep-alive --no-parent --mirror $URL
