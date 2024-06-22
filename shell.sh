#!/usr/bin/env bash

debug_pipe() {
    cat > /dev/stderr
}

debug() {
    echo "[${shell_directory:--}] [${shell_env_file:--}]" "$@" | debug_pipe
}

setup() {
    set -o errexit
    set -o pipefail
    set -o nounset
}
setup
# todo make everything local

# hooks

# todo make this a login hook
load_bin() {
    setup
    # usage load_bin directory
    local shell_directory="$1"

    local bin_dir
    bin_dir="$(readlink -f "$shell_directory/$SHELL_BIN_DIR")"
    #bin_dir="$(readlink -f "$SHELL_BIN_DIR")"
    if [ -d "$bin_dir" ]; then
        debug loading scripts in "$SHELL_BIN_DIR"
        # scripts in bin_dir should override regular scripts
        #export PATH="$PATH:$bin_dir"
        echo "$bin_dir:$PATH"
        # todo supress this output
        echo | debug_pipe
        ls -h "$bin_dir" | debug_pipe
        echo | debug_pipe
    else
        echo "$PATH"
    fi
}

unset_shell() {
    # shellcheck disable=SC2086
    unset ${!shell_*}
}

import() {
    setup
    #local shell_target="$1"
    #local shell_directory=asd
    shell_target="$1"
    shell_directory=asd
    unset shell_env_file

    if [ -d "$shell_target" ]; then
        shell_directory="$shell_target"
        #debug no exists? "$shell_directory"
        # in case it was set above
        #unset env_file
        #env_file="$directory/$SHELL_ENV_FILE"
        #echo $shell_env_file
    else
        shell_directory="$(dirname "$shell_target")"
        local shell_env_file
        shell_env_file="$(basename "$shell_target")"
        #debug exists? "$shell_env_file"
    fi

    post_hooks() {
        # todo pass and unset - what is this
        # todo order should not matter - but it does!
        PATH="$(load_bin "$shell_directory")"
        export PATH
        unset "$SHELL_BIN_DIR"

        # usage load_import directory
        if [ -z "${SHELL_IMPORTS+x}" ]; then
            return 0
        fi
        local IFS=':'
        shell_imports="$SHELL_IMPORTS"
        unset SHELL_IMPORTS
        for shell_import in $shell_imports; do
            import "$shell_directory/$shell_import"
        done
    }

    load() {
        if [ -f "$shell_directory/$shell_env_file" ]; then
            local shell_old_dir="$PWD"
            cd "$shell_directory"
            # shellcheck disable=SC1090
            source "$shell_env_file"
            set +x
            cd "$shell_old_dir"
        fi

        post_hooks
    }

    # todo test if env_file ends with shell env file
    if [ -z "${shell_env_file+x}" ]; then
        debug LOAD DEFAULT
        local shell_env_file="$SHELL_ENV_FILE"
        load
        # no worries if SHELL_ENV_FILE doesn't exist
    else
        debug LOAD EXPLICIT
        # must exist
        if [ ! -f "$shell_directory/$shell_env_file" ]; then
            debug env file \""$shell_env_file"\" in dir \""$shell_directory"\" does not exist
            exit 1
        fi

        load
    fi
    # todo post load hooks
    #echo "${shell_directory?}:${shell_env_file:-default}"
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
    setup
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

    #local IFS=':'
    #read -r shell_directory shell_environment <<< "$(import "$target")"
    if [ -d "$XDG_CONFIG_HOME/shell.sh" ]; then
        echo "$XDG_CONFIG_HOME/shell.sh"
        import "$XDG_CONFIG_HOME/shell.sh"
    fi
    import "$target"
    # run interactively
    shell_directory="$(basename "$(realpath "$shell_directory")")"
    shell_env_file="${shell_env_file:-default}"
    # todo make sure everything was local and nothing propogated up?

    # run a command
    if [ "$#" -gt 0 ]; then
        # todo should this have a command? command "$@"
        "$@"
        return "$?"
    fi

    # todo this looks wrong
    debug entering "$shell_directory" "$shell_env_file"
    # todo should this have a command? command "$SHELL
    ${SHELL_SHELL:-$SHELL}
    debug exiting "$shell_directory" "$shell_env_file"
}
shell.sh "$@"
