#!/usr/bin/env bash

set -e

# only set if unset?? naw
SHELL_ENV_FILE=shell.env
SHELL_BIN_DIR=bin

#set -x
# todo parse flags
# --help
# echo "$0" [-d|--directory=dir] <target> [--] [arg1] [arg2] [arg3] [arg...]
# --version
# echo shell.sh no version yet

# default to current directory
default_target=.
if [ "$1" == -- ]; then
    # shell.sh -- [args]
    target="$default_target"
    shift
else
    # shell.sh target -- [args]
    # shell.sh
    # shell.sh target [args]
    if [ -n "${1+x}" ]; then
        target="$1"
        shift
    else
        target="$default_target"
    fi

    if [ "$1" == -- ]; then
        # shell.sh target -- [args]
        shift
    else
        # shell.sh
        # shell.sh target [args]
        true
    fi
fi

if [ -d "$target" ]; then
    directory="$target"
    #env_file="$directory/$SHELL_ENV_FILE"
else
    directory="$(dirname "$target")"
    env_file="$target"
fi
# todo allow --directory
shell_directory="$(basename "$(realpath "$directory")")"
shell_environment="${environment:-default environment}"

# todo pre load hooks
echo entering "$shell_directory" "$shell_environment"
# todo test if env_file ends with shell env file
if [ -z "${env_file+x}" ]; then
    env_file="$directory/$SHELL_ENV_FILE"
    if [ -f "$env_file" ]; then
        set -x
        source "$env_file"
        set +x
    fi
    # no worries if SHELL_ENV_FILE doesn't exist
else
    # must exist
    if [ ! -f "$env_file" ]; then
        echo env file \""$env_file"\" does not exist
        exit 1
    fi

    set -x
    source "$env_file"
    set +x
fi
# todo post load hooks
if [ "$#" -gt 0 ]; then
    "$@"
else
    "$SHELL"
fi
echo exiting "$shell_directory" "$shell_environment"

exit 0

read_config_file() {
    file="$1"
    if [ ! -f "$file" ]; then
        return 0
    fi

    .() {
        echo hi
        set +x
        read_config_file "$1"
        set -x
    }
    #export -f .
    set -x
    source "./$file"
    set +x
    #SHELL_ENV="$(dirname "$file")"
    SHELL_ENV="$file"
    export SHELL_ENV
    # file can override SHELL_ENV if it export SHELL_ENV
    # actually now it can't
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
#read_config "$1"

#workspace_dir=
#workspace_dir="$(readlink -f "$(dirname "$0")")"

# todo make this a login hook
load_bin() {
    #bin_dir="$(readlink -f "$workspace_dir/$SHELL_BIN_DIR")"
    bin_dir="$(readlink -f "$SHELL_BIN_DIR")"
    if [ -d "$bin_dir" ]; then
        echo loading scripts in "$SHELL_BIN_DIR"
        # scripts in bin_dir should override regular scripts
        #export PATH="$PATH:$bin_dir"
        export PATH="$bin_dir:$PATH"
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
