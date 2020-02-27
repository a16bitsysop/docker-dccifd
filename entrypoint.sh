#!/bin/sh
echo "Starting at $(date +'%xx %X')"
echo "Passed varaibles..."
echo "REMOTEIP= $REMOTEIP"
echo "SOCKET= $SOCKET"
echo
#If SOCKET set start listening to socket, otherwise start listen to *
[ -z "$REMOTEIP" ] && REMOTEIP="172.16.0.0/12"
PORT="*,10045,$REMOTEIP"
[ -n "$SOCKET" ] && PORT="/var/dcc/sock/dccifd"

#edit dcc_conf so start-dccifd works
sed -i -e 's+DCCM_LOG_AT=.*+DCCM_LOG_AT=NEVER+g' \
-e 's+DCCM_REJECT_AT=.*+DCCM_REJECT_AT=MANY+g' \
-e 's+DCCIFD_ARGS=.*+DCCIFD_ARGS="-SHELO -Smail_host -SSender -SList-ID -b -p '"$PORT"'"+g' \
/var/dcc/dcc_conf

chown dcc:dcc log sock
sh -c "crond -f & /var/dcc/libexec/start-dccifd;"

#use dccifd directly to avoid writing to docker container
#sh -c "crond -f & ./libexec/dccifd -SHELO -Smail_host -SSender -SList-ID -b -p$PORT -tCMN,NEVER,MANY -l/var/dcc/log -Idcc;"

