FROM alpine:3.11
LABEL maintainer "Duncan Bellamy <dunk@denkimushi.com>"

WORKDIR /tmp
RUN apk add --update --no-cache build-base wget && \
addgroup -S _dcc && adduser -S -h /var/dcc --ingroup _dcc _dcc && \
wget https://www.dcc-servers.net/dcc/source/dcc.tar.Z && \
tar -xzf dcc.tar.Z && cd dcc-* && \
./configure --disable-dccm --disable-server --with-uid=_dcc --with-max-db-memory=64 && \
sed -i 's+DCC_UNIX+DCC_UNIX\n#include <sys\/types.h>+g' include/dcc_types.h && \
make && make install && cd ../ && rm -Rf dcc* && \
mkdir /var/dcc/sock && chown _dcc:_dcc /var/dcc/sock && \
sed -i -e 's+DCCM_LOG_AT=.*+DCCM_LOG_AT=NEVER+g' \
-e 's+DCCM_REJECT_AT=.*+DCCM_REJECT_AT=MANY+g' \
#   listen to sock file 
#-e 's+DCCIFD_ARGS="+DCCIFD_ARGS="-b -p /var/dcc/sock/dccifd +g' /var/dcc/dcc_conf
#   listen to port
-e 's+DCCIFD_ARGS="+DCCIFD_ARGS="-b -p *,10045,172.0.0.0/8 +g' /var/dcc/dcc_conf


# Run cron jobs clean every week, update every month
RUN echo -e '@weekly    /var/dcc/libexec/cron-dccd\n\' > /etc/crontabs/root

#@monthly    /var/dcc/libexec/updatedcc\n\' > /etc/crontabs/root

WORKDIR /var/dcc

ENTRYPOINT ["sh", "-c", "{ crond -f & /var/dcc/libexec/start-dccifd; }"]

#run on container network (no need to expose ports on container network)
#other containers use dccifd as hostname to connect to
#docker container run --net MYNET --name dccifd -d a16bitsysop/dccifd

#run without connecting to container network exposing ports
#docker container run -p 10045:10045 --name dccifd -d a16bitsysop/dccifd
