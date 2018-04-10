#!/bin/bash
video_list="video.txt"
total=$(wc -l $video_list | awk '{ print $1 }')
counter=0

if command -v youtube-dl >/dev/null 2>&1 ; then
	    echo "$(date) Download Started..."
	else
	    echo "youtube-dl not found. Please, install it: 'sudo apt-get install youtube-dl'"
	    exit
fi

for video in $(cat $video_list); do
	counter=$(($counter + 1))
	echo "[$counter/$total]: " $video
	youtube-dl -f 22 -o '%(title)s.%(ext)s' $video
done

echo "$(date) Download Finished!"
