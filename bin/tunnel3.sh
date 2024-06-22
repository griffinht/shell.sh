#!/bin/sh

set -e

echo todo shell_shell
exit 1

temp="$(mktemp -d)"
# temp dir only needed if tunnel socket isn't set
socket="${SSH_TUNNEL_SOCKET?}"
echo tunneling "${SSH_TUNNEL_HOST_SOCKET?}" on "${SSH_HOST?}" to "$socket"
ssh.sh -N -L "$socket:${SSH_TUNNEL_HOST_SOCKET}" &
pid="$!"
cleanup() {
    #echo todo bug where if ssh.sh fails the shell remains open but dead, fix would be wait for both and kill on eithe ridk nvm
    echo cleaning up "$temp"
    kill "$pid"
    rm "$socket"
    rm -r "$temp"
}
trap cleanup INT
"$SHELL" "$@" || exit_code="$?"
cleanup
exit "${exit_code:-0}"
