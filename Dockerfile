FROM alpine:latest

COPY build-git.sh /usr/local/bin/
RUN apk update && apk add build-base git

ENTRYPOINT ["/bin/sh"]
