# docker-dccifd
Alpine Based Dockerfile to install [dccifd](https://www.dcc-servers.net/dcc/) as a docker container that accept connections on a port or sockfile depending on environment variables when it is run.

[![Docker Pulls](https://img.shields.io/docker/pulls/a16bitsysop/dccifd.svg?style=plastic)](https://hub.docker.com/r/a16bitsysop/dccifd/)
[![Docker Stars](https://img.shields.io/docker/stars/a16bitsysop/dccifd.svg?style=plastic)](https://hub.docker.com/r/a16bitsysop/dccifd/)
[![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/a16bitsysop/dccifd/latest?style=plastic)](https://hub.docker.com/r/a16bitsysop/dccifd/)
[![Github SHA](https://img.shields.io/badge/dynamic/json?style=plastic&color=orange&label=Github%20SHA&query=object.sha&url=https%3A%2F%2Fapi.github.com%2Frepos%2Fa16bitsysop%2Fdocker-dccifd%2Fgit%2Frefs%2Fheads%2Fmaster)](https://github.com/a16bitsysop/docker-dccifd)
[![GitHub Super-Linter](https://github.com/a16bitsysop/docker-dccifd/workflows/Super-Linter/badge.svg)](https://github.com/marketplace/actions/super-linter)

## Github
Github Repository: [https://github.com/a16bitsysop/docker-dccifd](https://github.com/a16bitsysop/docker-dccifd)

## Environment Variables
| Name     | Desription                                               | Default               |
| -------- | -------------------------------------------------------- | --------------------- |
| REMOTEIP | allowed remote IP range, "swarm" allows all ips          | 172.16.0.0/12         |
| SOCKET   | makes dccifd listen to the /var/dcc/socket/dccifd socket | listen all interfaces |
| TIMEZONE | Timezone to use inside the container, eg Europe/London   | unset                 |

## Cron
A cron job is also started for the dcc user to tidy the log files for messages, update script can be started as well but it will not auto update
on Alpine linux just yet.

## Examples
**To run on container network (no need to expose ports on container network) the remote containers use dccifd as hostname of server**
```bash
#docker container run --net MYNET --name dccifd --restart=unless-stopped -d a16bitsysop/dccifd
```

**To run without connecting to container network exposing ports (accessible from host network)**
```bash
#docker container run -p 10045:10045 --name dccifd --restart=unless-stopped -d a16bitsysop/dccifd
```

**To run with tmpfs volume for /var/dcc/log and allowed remote ip/subnet**
```bash
#docker container run --mount type=tmpfs,destination=/tmp --mount type=tmpfs,destination=/var/dcc/home -p 10045:10045 --env REMOTEIP=192.168.0.0/24 --name dccifd -d a16bitsysop/dccifd
```

**To run using the sock file**
```bash
#docker container run --env SOCKET=yes --name dccifd --restart=unless-stopped -d a16bitsysop/dccifd
```
