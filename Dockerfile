FROM alpine:latest

#COPY build-git.sh /usr/local/bin/
RUN apk update && apk add --no-cache build-base curl && adduser -S -h /var/dcc _dcc && cd /tmp && \
curl --connect-timeout 30 --max-time 600 -o dcc.tar.Z https://www.dcc-servers.net/dcc/source/dcc.tar.Z && \
tar -xzf dcc.tar.Z && cd dcc-* && ./configure --disable-dccm --disable-server --with-uid=_dcc --with-max-db-memory=64 && \
sed -i 's/DCC_UNIX/DCC_UNIX\n#include <sys\/types.h>/' include/dcc_types.h && make && make install && cd ../ && rm -Rf dcc*

#	run_sudo_command('ln -s /var/dcc/libexec/cron-dccd /etc/cron.daily/cron-dccd')
#	run_sudo_command('ln -s /var/dcc/libexec/updatedcc /etc/cron.daily/updatedcc')

#CMD ["/var/dcc/libexec/start-dccifd"]
CMD ["/bin/sh"]
