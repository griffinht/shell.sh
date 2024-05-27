#!/usr/bin/env bash

set -e
set -o errexit
set -o pipefail
set -o nounset
# todo make everything local

# hooks
#
load_import() {
    # usage load_import directory
    unset "${!shell_*}"
    local shell_directory="$1"

    if [ -z "${SHELL_IMPORTS+x}" ]; then
        return 0
    fi
    local IFS=':'
    shell_imports="$SHELL_IMPORTS"
    unset SHELL_IMPORTS
    for shell_import in $shell_imports; do
        echo "$shell_directory" "$shell_import"
        import "$shell_directory/$shell_import"
    done
}

# todo make this a login hook
load_bin() {
    # usage load_bin directory
    unset "${!shell_*}"
    local shell_directory="$1"

    local bin_dir
    bin_dir="$(readlink -f "$shell_directory/$SHELL_BIN_DIR")"
    #bin_dir="$(readlink -f "$SHELL_BIN_DIR")"
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
    unset "$SHELL_BIN_DIR"
}


import() {
    # usage import target
    # shellcheck disable=SC2086
    unset ${!shell_*}
    local shell_target="$1"
    local shell_directory

    if [ -d "$shell_target" ]; then
        shell_directory="$shell_target"
        # in case it was set above
        #unset env_file
        #env_file="$directory/$SHELL_ENV_FILE"
    else
        shell_directory="$(dirname "$shell_target")"
        local shell_env_file
        shell_env_file="$(basename "$shell_target")"
    fi

    load() {
        # usage import target
        unset "${!shell_*}"
        local shell_directory="$1"
        shell_env_file="$2"

        local shell_old_dir="$PWD"

        cd "$shell_directory"
        set -x
        # shellcheck disable=SC1090
        source "$shell_env_file"
        set +x
        cd "$shell_old_dir"

        # todo pass and unset - what is this
        # todo order should not matter - but it does!
        load_bin "$shell_directory"
        # todo explicit pass and unset
        load_import "$shell_directory"
    }

    # todo test if env_file ends with shell env file
    if [ -z "${shell_env_file+x}" ]; then
        local shell_env_file="$SHELL_ENV_FILE"
        if [ -f "$shell_directory/$shell_env_file" ]; then
            load "$shell_directory" "$shell_env_file"
        fi
        # no worries if SHELL_ENV_FILE doesn't exist
    else
        # must exist
        if [ ! -f "$shell_directory/$shell_env_file" ]; then
            echo env file \""$shell_env_file"\" in dir \""$shell_directory"\" does not exist
            exit 1
        fi

        load "$shell_directory" "$shell_env_file"
    fi
    # todo post load hooks
    shell_return_directory="$shell_directory"
    shell_return_environment="${shell_env_file:-default}"
}




# only set if unset?? naw
# todo readonly???
SHELL_ENV_FILE=shell.env
SHELL_BIN_DIR=bin

#set -x
# todo parse flags
# --help
# echo "$0" [-d|--directory=dir] <target> [--] [arg1] [arg2] [arg3] [arg...]
# --version
# echo shell.sh no version yet

shell.sh() {
    # default to current directory
    declare -r default_target=.
    local target="$SHELL_ENV_FILE"
    if [ "$#" -gt 0 ]; then
        if [ "$1" == -- ]; then
            local target="$default_target"
            shift
        else
            local target="$1"
            shift

            if [ "$#" -gt 0 ] && [ "$1" == -- ]; then
                shift
            fi
        fi
    fi

    import "$target"
    local shell_directory="$shell_return_directory"
    local shell_environment="$shell_return_environment"
    unset "${!shell_return_*}"
    # todo make sure everything was local and nothing propogated up?

    # run a command
    if [ "$#" -gt 0 ]; then
        # todo should this have a command? command "$@"
        "$@"
        return "$?"
    fi

    # run interactively
    shell_directory="$(basename "$(realpath "$shell_directory")")"
    # todo this looks wrong
    echo entering "$shell_directory" "$shell_environment"
    # todo should this have a command? command "$SHELL
    "$SHELL"
    echo exiting "$shell_directory" "$shell_environment"
}
shell.sh "$@"
