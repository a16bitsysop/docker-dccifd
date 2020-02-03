# docker-dccifd
Dockerfile to install [dccifd](https://www.dcc-servers.net/dcc/) as a docker container that accept connections on a port or sockfile depending on environment variables when it is run.

Environment variable REMOTEIP is the allowed remote IP range, defaults to 172.16.0.0/12 if not set.

Environment variable SOCKET makes dccifd listen to the /var/dcc/socket/dccifd socket file instead.

A cron job is also started for the dcc user to tidy the log files for messages, update script can be started as well but it will not auto update
on Alpine linux just yet.

To run on container network (no need to expose ports on container network) the remote containers use dccifd as hostname of server
```
#docker container run --net MYNET --name dccifd --restart=unless-stopped -d a16bitsysop/dccifd
```

To run without connecting to container network exposing ports (accessible from host network)
```
#docker container run -p 10045:10045 --name dccifd --restart=unless-stopped -d a16bitsysop/dccifd
```

To run with tmpfs volume for /var/dcc/log and allowed remote ip/subnet
```
#docker container run --mount type=tmpfs,destination=/var/dcc/log -p 10045:10045 --env REMOTEIP=192.168.0.0/24 --name dccifd a16bitsysop/dccifd

```

To run using the sock file
```
#docker container run --env SOCKET=yes --name dccifd --restart=unless-stopped -d a16bitsysop/dccifd
```
