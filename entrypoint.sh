#!/bin/sh
echo "Starting dccifd at $(date +'%x %X')"
echo "Passed varaibles..."
echo "REMOTEIP= $REMOTEIP"
echo "SOCKET= $SOCKET"
echo
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
