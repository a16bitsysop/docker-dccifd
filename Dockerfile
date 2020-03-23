FROM alpine:3.11
LABEL maintainer "Duncan Bellamy <dunk@denkimushi.com>"

RUN apk add dcc-dccifd --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/

WORKDIR /usr/local/bin
COPY entrypoint.sh ./
WORKDIR /var/dcc
ENTRYPOINT [ "entrypoint.sh" ]

VOLUME [ "/var/dcc/log" ]

EXPOSE 10045
