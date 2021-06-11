#!/usr/bin/python3

#Paolo Frigo, https://scriptinglibrary.com 

import speedtest #pip3 install speedtest-cli
import os
from datetime import datetime

logfile    = "speedtest.log"

isp        = speedtest.Speedtest()
srv        = isp.get_best_server()
downstream = "{0:,.2f} Mb".format(float(isp.download()/10**6))
upstream   = "{0:,.2f} Mb".format(float(isp.upload()/10**6))
latency    = "{0:,.0f} ms".format(float(srv['latency']))
update     =  datetime.strftime(datetime.now(),'%d/%m/%y %I:%M%p')

with open(logfile, 'a+') as file:
    file.write(F"{update},{downstream},{upstream},{latency}\n")
print (f"{logfile} updated")