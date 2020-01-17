# docker-dccifd
Dockerfile to install dccifd as a docker container that accept connections on by port or sockfile depending on how it is run.

A cron job is also started to tidy the log files for messages, update script can be started as well but it will not auto update
on a Alpine linux just yet.

To run on container network (no need to expose ports on container network) the remote containers use dccifd as hostname of server
```#docker container run --net MYNET --name dccifd -d a16bitsysop/dccifd```

To run without connecting to container network exposing ports (accessible from host network)
```#docker container run -p 10045:10045 --name dccifd -d a16bitsysop/dccifd```

To run using the sock file to communicate comment out the port line and uncomment the sock line and build image again.
