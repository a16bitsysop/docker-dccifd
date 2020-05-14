#!/bin/sh
echo "Passed varaibles..."
echo "REMOTEIP= $REMOTEIP"
echo "SOCKET= $SOCKET"
echo '$TIMEZONE=' $TIMEZONE
echo

if [ -n "$TIMEZONE" ]
then
  echo "Waiting for DNS"
  ping -c1 -W60 google.com || ping -c1 -W60 www.google.com || ping -c1 -W60 google-public-dns-b.google.com
  apk add --no-cache tzdata
  if [ -f /usr/share/zoneinfo/"$TIMEZONE" ]
  then
    echo "Setting timezone to $TIMEZONE"
    cp /usr/share/zoneinfo/"$TIMEZONE" /etc/localtime
    echo "$TIMEZONE" > /etc/timezone
  else
    echo "$TIMEZONE does not exist"
  fi
  apk del tzdata
fi

echo "Starting dccifd at $(date +'%x %X')"
#If SOCKET set start listening to socket, otherwise start listen to passed ip or 172.16.0.0/12
if [ -z "$REMOTEIP" ]
then
  REMOTEIP="172.16.0.0/12"
elif [ "$REMOTEIP" = "swarm" ]
then
  REMOTEIP="0.0.0.0-254.254.254.254"
fi
PORT="*,10045,$REMOTEIP"

if [ -n "$SOCKET" ]
then
 	PORT="/var/dcc/sock/dccifd"
 	chown dcc:dcc sock
fi
#edit dcc_conf so start-dccifd works
sed -i -e 's+DCCIFD_ARGS=.*+DCCIFD_ARGS="-SHELO -Smail_host -SSender -SList-ID -b -p '"$PORT"'"+g' \
/var/dcc/dcc_conf

chown dcc:dcc log
sh -c "crond -f & /var/dcc/libexec/start-dccifd;"
