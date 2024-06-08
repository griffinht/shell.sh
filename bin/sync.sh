#!/bin/sh

set -xe

project=compose
volume=application

if [ -n "${SSH_HOST+x}" ]; then
    scp -r "$volume"/* "${SSH_HOST?}:/var/lib/docker/volumes/${project}_$volume/_data"
fi
#docker compose restart machine
