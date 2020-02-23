FROM alpine:3.11
LABEL maintainer "Duncan Bellamy <dunk@denkimushi.com>"

WORKDIR /tmp
RUN apk add --no-cache build-base && \
addgroup -S dcc && adduser -S -h /var/dcc --ingroup dcc dcc && \
wget https://www.dcc-servers.net/dcc/source/dcc.tar.Z && \
tar -xzf dcc.tar.Z && cd dcc-* && \
./configure --disable-dccm --disable-server \
                --bindir="/usr/bin" \
                --mandir="/usr/man" \
		--with-uid=dcc \
		--with-max-db-memory=64 && \
sed -i 's+DCC_UNIX+DCC_UNIX\n#include <sys\/types.h>+g' include/dcc_types.h && \
make && make install && cd ../ && rm -Rf dcc* && \
cd /var/dcc && mkdir sock && chown dcc:dcc sock && \
apk del build-base && \
crontab -d -u root && \
echo '@daily /var/dcc/libexec/cron-dccd' | crontab -u dcc - && \
chmod 755 /usr/bin/cdcc && \
cd libexec && rm dccsight updatedcc uninstalldcc /usr/bin/dccproc

WORKDIR /usr/local/bin
COPY entrypoint.sh ./
WORKDIR /var/dcc
ENTRYPOINT [ "entrypoint.sh" ]

VOLUME [ "/var/dcc/log" ]

EXPOSE 10045
