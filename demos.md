confusing!

# Load environment variables to the current shell

Without `shell.sh`

```
$ . ./prod.env
$
```

With `shell.sh`

```
$ shell.sh prod.env
$ 
```

# Add custom scripts to the PATH

```
scripts
```

Without `shell.sh`

```
$ export PATH="PATH:$PWD/scripts"
$ myscript.sh
```

# Run a hook

```
hooks/
- login
- exit
- cleanup
```

Without `shell.sh`

```
$ ./hooks/login
hello there
$ ./hooks/exit
exiting
```

With `shell.sh`

```
$ shell.sh
hello there
$ exit
exiting...
```

```
$ shell.sh
hello there
$ cleanup() {
    echo hi
}
$ trap BRUH
$ kill -SIGINT $PID
cleanup
```
