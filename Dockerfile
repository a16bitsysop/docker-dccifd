FROM alpine:3.12
LABEL maintainer "Duncan Bellamy <dunk@denkimushi.com>"

RUN apk add --no-cache dcc-dccifd \
&& mkdir /var/dcc/sock && chown dcc:dcc /var/dcc/sock

WORKDIR /usr/local/bin
COPY travis-helpers/set-timezone.sh entrypoint.sh ./
WORKDIR /var/dcc

ENTRYPOINT [ "entrypoint.sh" ]
VOLUME /var/dcc/log
EXPOSE 10045
