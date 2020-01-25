FROM alpine:3.11
LABEL maintainer "Duncan Bellamy <dunk@denkimushi.com>"

WORKDIR /tmp
RUN apk add --no-cache build-base wget && \
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
mkdir /var/dcc/sock && chown dcc:dcc /var/dcc/sock 

RUN apk del build-base wget

# Run cron jobs clean every week
RUN echo '@weekly /var/dcc/libexec/cron-dccd' | crontab -u dcc -

#remove suid bits
RUN chmod 755 /var/dcc/libexec/dccsight
WORKDIR /usr/bin
RUN chmod 755 cdcc dccproc
WORKDIR /var/dcc/libexec
RUN rm updatedcc uninstalldcc

WORKDIR /usr/local/bin
COPY entrypoint.sh ./
WORKDIR /var/dcc
ENTRYPOINT [ "entrypoint.sh" ]

EXPOSE 10045
