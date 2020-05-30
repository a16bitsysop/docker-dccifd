FROM alpine:3.12
LABEL maintainer "Duncan Bellamy <dunk@denkimushi.com>"

RUN sed -i -e 's/v[[:digit:]]\..*\//edge\//g' /etc/apk/repositories \
&& apk add --no-cache dcc-dccifd \
&& mkdir /var/dcc/sock && chown dcc:dcc /var/dcc/sock

WORKDIR /usr/local/bin
COPY entrypoint.sh ./
WORKDIR /var/dcc

ENTRYPOINT [ "entrypoint.sh" ]
VOLUME /var/dcc/log
EXPOSE 10045
