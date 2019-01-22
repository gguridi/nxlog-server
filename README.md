# NXLog server

This repository contains a docker image with [NXLog](https://nxlog.co). The intention is to use this docker to test our application integration before
committing our code into production.

The image can be found at [Docker Hub](https://cloud.docker.com/repository/docker/gguridi/nxlog-ce)

## Build

To build the image we must pass the version of NXLog we want to install inside. If not, the one declared inside the [Dockerfile](./Dockerfile) will be used.

```bash
docker build --build-arg BUILD=2.10.2150 -t {image-name} .
```

## Run

To simplest way to run this image is:

```bash
docker run -p 514:514/udp -p 515:515 -p 516:516 -it --name nxlog-container gguridi/nxlog-ce
```

Any parameter passed to the entrypoint will be appended to the nxlog start server binary.

## Testing

For testing purposes, we can generate a test JSON message using netcat.

```bash
echo -e '{"version": "1.1", "short_message":"Short message", "full_message":"Full message", "level":1}\0' | nc -u -w 5 localhost 514
```

Note that depending on the netcat installed in your operating system the command can vary slightly.

## Listeners

This image provides out of the box the following ways to communicate with NXLog.

### UDP

It listens automatically for UDP packets at port `514/udp`.

### TCP

It listens automatically for TCP connections at port `515/tcp`.

### SSL

It listens for TCP connections with SSL at port `516/tcp`. 

The repository comes with two certificates preinstalled that we can use to generate a secure connection with our NXLog server. 
For further information about how to connect with NXLog using SSL you can find an example at the 
[logrus-nxlog-hook](https://github.com/affectv/logrus-nxlog-hook#ssl-connection) plugin in Go.

### UDS

It listens at `/var/run/nxlog/devlog` for Unix Domain Socket connections.

To be able to use this outside the docker image please mount `/var/run/nxlog`.

## Outputs

This image provides out of the box different outputs.

### File

Automatically all the messages received will be dumped on `/tmp/output.log`

It's possible to override this location by passing an environment variable called `OUTPUT` to the container.

### Graylog

To enable this behaviour, we must pass the environment variable `GRAYLOG_HOST` to the container.

It can be configured using the following environment variables.
- `GRAYLOG_HOST`: ip or address where graylog is running.
- `GRAYLOG_PORT`: port where graylog is listening (default 12201).
- `GRAYLOG_OUTPUT`: connection type to establish with graylog (default GELF_TCP). Available options can be found [here](https://nxlog.co/docs/nxlog-ce/nxlog-reference-manual.html#xm_gelf)

## Configuration

Generic configuration can be added through environment variables.

- `LOG_LEVEL`: Specifies the log level used by NXLog to process the messages.
