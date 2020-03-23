#!/bin/sh
echo "Starting dccifd at $(date +'%x %X')"
echo "Passed varaibles..."
echo "REMOTEIP= $REMOTEIP"
echo "SOCKET= $SOCKET"
echo
#If SOCKET set start listening to socket, otherwise start listen to *
[ -z "$REMOTEIP" ] && REMOTEIP="172.16.0.0/12"
PORT="*,10045,$REMOTEIP"
if [ -n "$SOCKET" ]; then
 	PORT="/var/dcc/sock/dccifd"
 	chown dcc:dcc log sock
fi
#edit dcc_conf so start-dccifd works
sed -i -e 's+DCCM_LOG_AT=.*+DCCM_LOG_AT=NEVER+g' \
-e 's+DCCM_REJECT_AT=.*+DCCM_REJECT_AT=MANY+g' \
-e 's+DCCIFD_ARGS=.*+DCCIFD_ARGS="-SHELO -Smail_host -SSender -SList-ID -b -p '"$PORT"'"+g' \
/var/dcc/dcc_conf

sh -c "crond -f & /var/dcc/libexec/start-dccifd;"
