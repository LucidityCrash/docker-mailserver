#! /bin/bash
while true; do
    if ! pgrep -x "getmail" > /dev/null
    then 
        #/usr/bin/getmail --getmaildir /etc/getmailrc.d --rcfile getmailrc.file
        /usr/bin/getmail --getmaildir /var/lib/getmail --rcfile /etc/getmailrc.d/getmailrc
        sleep 300
    fi
done