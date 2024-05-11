# Locations

Highest priority configurations override the lower priority ones
todo security?

1. `shell.sh file.env`
2. `./shell.env`
3. `*../shell.env`
4. `$XDG_CONFIG_HOME/shell.sh/shell.env`
5. ?? `~/shell.sh/shell.env`

# Format

    technically this is executable lol

`shell.env`
```
. ./config.env
. ../otherconfig.env
. /full/path/to/otherconfig.env
export KEY=value
export OTHER_KEY='*J#@ED'
```

# Options

`SHELL_`
`SHELL_ENV_FILE` shell.env

# Environment variables

`SHELL_ENV`

The name of the current environment
