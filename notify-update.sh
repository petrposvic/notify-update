#!/bin/bash
# Simple script to check updates and send notification e-mail
#
# apt-get needs root permissions. Start this script with sudo.
#
# If sendemail throws error: No TLS support! SendEmail can't load required libraries. (try installing Net::SSLeay and IO::Socket::SSL)
# install both libraries: apt install libnet-ssleay-perl libio-socket-ssl-perl

MAIL_TO="petr@posvic.cz"
MAIL_FROM="notification@posvic.cz"
MAIL_SERVER="smtp.gmail.com:587"
MAIL_USER="notification@posvic.cz"

# Go to https://myaccount.google.com/lesssecureapps
# Enable 2-phase authentication, select Application Passwords and add new one
MAIL_PASS=""

# Edit cron (crontab -e) in root account and insert this line (without #):
# 0 2 * * * /path/to/this/script/notify-update.sh > /dev/null 2>&1

if [ ! -f /usr/bin/sendemail ]; then
  echo "Install sendemail!"
  echo "  sudo apt install sendemail"
  exit -1
fi

upd=`apt-get update`
msg=`apt-get -s upgrade | grep -i "^inst"`

if [ -z "$msg" ]; then
  echo "No updates"
  exit 1
fi

echo "Updates available, send notification to $MAIL_TO"
echo "Updates available for $HOSTNAME" | /usr/bin/sendemail -u "Update $HOSTNAME" \
  -f $MAIL_FROM -t $MAIL_TO \
  -s $MAIL_SERVER -xu $MAIL_USER -xp $MAIL_PASS \
  -o tls=yes > /dev/null 2>&1
