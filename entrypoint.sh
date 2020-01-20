#!/bin/sh

#If SOCKET set start listening to socket, otherwise start listen to *

PORT="*,10045,172.0.0.0/8"
[ -n "$SOCKET" ] && PORT="/var/dcc/sock/dccifd"

#edit dcc_conf so start-dccifd works
sed -i -e 's+DCCM_LOG_AT=.*+DCCM_LOG_AT=NEVER+g' \
-e 's+DCCM_REJECT_AT=.*+DCCM_REJECT_AT=MANY+g' \
-e 's+DCCIFD_ARGS=.*+DCCIFD_ARGS="-SHELO -Smail_host -SSender -SList-ID -b -p '"$PORT"'"+g' \
/var/dcc/dcc_conf

sh -c "crond -f & /var/dcc/libexec/start-dccifd;"
