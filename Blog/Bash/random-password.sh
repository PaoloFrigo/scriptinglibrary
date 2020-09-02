#!/bin/bash
# Paolo Frigo, https://www.scriptinglibrary.com

# credit for URANDOM: https://gist.github.com/earthgecko/3089509

# This scripts generates a strong password of 32 characters

# using PwGen 
#pwgen -sBy 32 1

# using Openssl
openssl rand -base64 32

# using URandom 
#cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
# use this for URandom on MacOS
#cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1
# this with more symbols
#cat /dev/urandom |  LC_CTYPE=C tr -dc "a-zA-Z0-9!@#$%^&*()_+?><~\`;'" | fold -w 32 | head -n 1
