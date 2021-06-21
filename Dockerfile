FROM alpine:3.14
LABEL maintainer="Duncan Bellamy <dunk@denkimushi.com>"

# hadolint ignore=DL3018
RUN apk add -u --no-cache dcc-dccifd \
&& mkdir /var/dcc/sock && chown dcc:dcc /var/dcc/sock

WORKDIR /usr/local/bin
COPY travis-helpers/set-timezone.sh entrypoint.sh ./
WORKDIR /var/dcc

ENTRYPOINT [ "entrypoint.sh" ]
VOLUME /var/dcc/log
EXPOSE 10045
