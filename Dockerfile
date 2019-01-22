FROM ubuntu:18.10

MAINTAINER Gorka Guridi <gorka.guridi@gmail.com>

EXPOSE 514/tcp 514/udp 516/tcp

ARG BUILD="2.10.2150"

ENV OUTPUT="/tmp/output.log"
ENV LOG_LEVEL="INFO"
ENV GRAYLOG_HOST=""
ENV GRAYLOG_PORT="12201"
ENV GRAYLOG_OUTPUT="GELF_TCP"

RUN apt-get update
RUN apt-get install -y python3-distutils python3-minimal wget
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py
RUN pip install j2cli

ADD https://nxlog.co/system/files/products/files/348/nxlog-ce_${BUILD}_ubuntu_bionic_amd64.deb /opt/
RUN apt install -y /opt/*.deb

ADD . /opt/nxlog/

ENTRYPOINT [ "/opt/nxlog/start.sh" ]
