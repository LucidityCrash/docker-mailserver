#! /bin/bash
while true; do
    for file in /etc/getmailrc.d/getmailrc*; do
        #/usr/bin/getmail --getmaildir /etc/getmailrc.d --rcfile getmailrc.file
        /usr/bin/getmail --getmaildir /var/lib/getmail --rcfile $file
    done
    sleep 300
done