#!/bin/sh

set -e

temp="$(mktemp -d)"
socket="$temp/socket"
export SSH_TUNNEL_SOCKET="$socket"
echo tunneling "$SSH_TUNNEL_HOST_SOCKET" on "$SSH_HOST" to "$SSH_TUNNEL_SOCKET"
ssh.sh -N -L "$socket:${SSH_TUNNEL_HOST_SOCKET}" &
pid="$!"
"$SHELL" "$@"
echo cleaning up "$temp"
kill "$pid"
rm -r "$temp"
