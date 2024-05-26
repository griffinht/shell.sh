# custom dev environments

make the readme the elevator pitch - SHORT AS POSSIBLE!!
hey bro heres the github try it out!
wget script
chmod +x script

then its like how do i use it??

# Installation

```sh
$ wget code.com/shell.sh 
$ chmod +x shell.sh
$ ./shell.sh
entered default shell environment
[default] $ exit
exited default shell environment
$ # consider adding shell.sh to your path!
$ export PATH="$PATH:$PWD"
$ shell.sh --version
$ # or just run the script with an explicit path
$ cd dir
$ ../shell.sh --version
$ bash ../shell.sh --version
```

is --help the first usability thing you want?

# Env var example

```sh
$ echo 'export MY_VAR=example' > shell.env
$ env | grep MY_VAR
$ shell.sh
[default] $ env | grep MY_VAR
MY_VAR=example
[default] $ exit
$
```

See [env var expansion] for more details

# Bin example

`bin/hello.sh`
```sh
#!/bin/sh

echo hello ${NAME:-unknown}
```

`shell.env`
```sh
export NAME=billy
```

```
bin/my_script.sh
shell.env
```

```sh
$ shell.sh 
$ ./bin/hello.sh
hello unknown
loaded hello.sh
[default] $ hello.sh
hello billy
[default] $ exit
$ hello.sh
cmd not found
```

See [bin hook] for more details

# Import example

    shell.sh can be run from anywhere!


# Docker example

```
prod.override.yml
compose.yml
prod.env
dev.env
```

## Location development

    spin up the app on my laptop

## Deploy to production

    deploy the app to my production server

`prod.env`
```
export SSH_HOST="root@prod"
export DOCKER_HOST="ssh://$SSH_HOST"
export COMPOSE_FILE=prod.yml
export DOMAIN=example.com
```

make this shorter and sweeter! introduce concepts one at a time! pretend its a demo! you shouldn't have to explain it!
```
$ shell.sh prod.env
entered prod envi
[prod] $ echo $DOCKER_HOST $COMPOSE_FILE
ssh://root@prod prod.yml
[prod] $ docker compose ps
running...
[prod] $ mount.sh
[prod] $ ls mnt
[prod] $ sudo unmount mnt
[prod] $ ssh.sh
root@prod $ w
uptime
root@prod $ exit
[prod] $ exit
exited prod
$ echo $DOCKER_HOST $COMPOSE_FILE

$ ..
```














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
