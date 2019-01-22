#!/bin/bash

j2 /opt/nxlog/nxlog.conf.j2 > /etc/nxlog/nxlog.conf

/usr/bin/nxlog "$@"
tail -f ${OUTPUT}
