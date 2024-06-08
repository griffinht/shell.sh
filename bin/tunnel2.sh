#!/bin/sh

set -e

temp="$(mktemp -d)"
echo "$SSH_HOST"
docker_socket="$temp/docker.socket"
ssh -N -L "$docker_socket":/var/run/docker.sock "${SSH_HOST?}" &
pid="$!"
export DOCKER_HOST="unix://$docker_socket"
"$SHELL"
echo cleaning up "$temp"
kill "$pid"
rm -r "$temp"
