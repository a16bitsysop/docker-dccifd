FROM alpine:3.11
LABEL maintainer "Duncan Bellamy <dunk@denkimushi.com>"

WORKDIR /tmp
RUN apk add --no-cache build-base wget && \
addgroup -S _dcc && adduser -S -h /var/dcc --ingroup _dcc _dcc && \
wget https://www.dcc-servers.net/dcc/source/dcc.tar.Z && \
tar -xzf dcc.tar.Z && cd dcc-* && \
./configure --disable-dccm --disable-server --with-uid=_dcc --with-max-db-memory=64 && \
sed -i 's+DCC_UNIX+DCC_UNIX\n#include <sys\/types.h>+g' include/dcc_types.h && \
make && make install && cd ../ && rm -Rf dcc* && \
mkdir /var/dcc/sock && chown _dcc:_dcc /var/dcc/sock 

RUN apk del build-base

# Run cron jobs clean every week, update every month
RUN echo -e '@weekly    /var/dcc/libexec/cron-dccd\n\' > /etc/crontabs/root

#@monthly    /var/dcc/libexec/updatedcc\n\' > /etc/crontabs/root

WORKDIR /usr/local/bin
COPY entrypoint.sh ./
WORKDIR /var/dcc
ENTRYPOINT [ "entrypoint.sh" ]

EXPOSE 10045
