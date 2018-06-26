#!/bin/bash
#author: Paolo Frigo, https://www.scriptinglibrary.com
video_list="videos.txt"
total=$(wc -l $video_list | awk '{ print $1 }')
counter=0
help="Please, install it: 
'sudo apt-get install youtube-dl' or 
'brew install youtube-dl'
for more info: https://github.com/rg3/youtube-dl"

if command -v youtube-dl >/dev/null 2>&1 ; then
	    echo "$(date) Download Started..."
	else
	    echo "youtube-dl not found. $help"
	    exit
fi

for video in $(cat $video_list); do
	counter=$(($counter + 1))
	echo "[$counter/$total]: " $video
	youtube-dl -f 22 -o '%(title)s.%(ext)s' $video
done

echo "$(date) Download Finished!"
