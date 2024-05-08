# `shell.sh` is not:

- a package manager
- a build system
- a deployment tool
- a shell
    - leave that to bash, fish, etc - no autocompletes!
- secret manager
- daemon
- secure!

# what can `shell.sh` do?

    todo deploy demos

install packages

build software

deploy anything

manage production

# what can't `shell.sh` do?

try using a package manager
install packages
- use `guix shell`
- or `nix shell`
- or `sudo apt install`
- or `docker run`
- or `curl | sh`

try using a build system
build software
- use `make`
- or `just`

try using a deployment tool
deploy things
- use `ssh`
- or terraform???

# so what is `shell.sh`?

# `shell.sh` is:
- general
- portable
    - it's one single POSIX script
- simple
- dumb
- extensible
    - see extensions todo link

# `shell.sh` is not:

- reproducible
    - why would it be? it's just a bunch of scripts
- predictable
    - expect your scripts to break as the weather changes
- cross platform?
    - maybe in the future it could be?
- easy
    - `shell.sh` won't do anything for you
- magic
    - `shell.sh` 
- cloud native
    - what?
- secure (yet?)
