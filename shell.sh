#!/bin/sh

set -e

read_config() {
}
config="$1"

echo "entering $env"
. "./$env"

scripts_dir="$(readlink -f "$(dirname "$0")")/scripts"
PATH="$PATH:$scripts_dir"

echo
echo scripts:
ls -h "$scripts_dir"

"$SHELL"

echo "exited $env"
