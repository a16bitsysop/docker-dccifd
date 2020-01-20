# docker-dccifd
Dockerfile to install [dccifd](https://www.dcc-servers.net/dcc/) as a docker container that accept connections on a port or sockfile depending on environment variables when it is run.

A cron job is also started to tidy the log files for messages, update script can be started as well but it will not auto update
on Alpine linux just yet.

To run on container network (no need to expose ports on container network) the remote containers use dccifd as hostname of server
```
#docker container run --net MYNET --name dccifd --restart=unless-stopped -d a16bitsysop/dccifd
```

To run without connecting to container network exposing ports (accessible from host network)
```
#docker container run -p 10045:10045 --name dccifd --restart=unless-stopped -d a16bitsysop/dccifd
```

To run using the sock file
```
#docker container run --env SOCKET=yes --name dccifd --restart=unless-stopped -d a16bitsysop/dccifd
```
