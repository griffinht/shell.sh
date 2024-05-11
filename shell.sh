#!/bin/sh

set -e

SHELL_ENV_FILE=shell.env
SHELL_BIN_DIR=bin

read_config_file() {
    file="$1"
    if [ ! -f "$file" ]; then
        return 0
    fi

    #SHELL_ENV="$(dirname "$file")"
    SHELL_ENV="$file"
    export SHELL_ENV
    # file can override SHELL_ENV if it export SHELL_ENV
    set -x
    . "./$file"
    set +x
}

read_config() {
    read_config_file "$XDG_CONFIG_HOME/shell.sh/shell.env"

    read_config_up() {
        dir="$PWD"
        while [ "$dir" != "/" ]; do
            file="$dir/$SHELL_ENV_FILE"
            if [ -f "$file" ]; then
                read_config_file "$file"
            fi
            dir="$(dirname "$dir")"
        done
    }
    #read_config_up

    if [ -n "$1" ]; then
        read_config_file "$1"
        export SHELL_ENV="${SHELL_ENV?could not load configuration, todo rerun with --debug}"
    else
        export SHELL_ENV="${SHELL_ENV:-unknown}"
    fi
}
read_config "$1"

#workspace_dir=
#workspace_dir="$(readlink -f "$(dirname "$0")")"

load_bin() {
    #bin_dir="$(readlink -f "$workspace_dir/$SHELL_BIN_DIR")"
    bin_dir="$(readlink -f "$SHELL_BIN_DIR")"
    if [ -d "$bin_dir" ]; then
        echo loading scripts in "$SHELL_BIN_DIR"
        export PATH="$PATH:$bin_dir"
        # todo supress this output
        echo
        ls -h "$bin_dir"
        echo
    fi
}
load_bin

# todo login hooks
echo "entered $SHELL_ENV"

# todo make configurable SHELL_SHELL=$SHELL by default?
"$SHELL"

# todo exit hooks
echo "exited $SHELL_ENV"
