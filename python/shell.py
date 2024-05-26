#!/usr/bin/env python3

import argparse
import subprocess
from dotenv import load_dotenv
import os

# argparse
# code mutate


def getenv(key, default=None):
    value = None
    if key in os.environ:
        value = os.environ[key]
        del os.environ[key]
    else:
        value = default

    return value


def load_bin():
    shell_bin_dir = getenv("SHELL_BIN_DIR", "bin")
    if os.path.isdir(shell_bin_dir):
        print(os.listdir(shell_bin_dir))
        path = os.getenv("PATH", "")
        # todo priority make sure this overrides
        os.environ["PATH"] = f"{path}:{shell_bin_dir}"


def load_import():
    shell_imports = getenv("SHELL_IMPORT", "").split(":")
    for shell_import in shell_imports:
        print(f"importing {shell_import}")
        #load(shell_import)


def load(file):
    load_dotenv(dotenv_path=file)
    # load hooks here
    load_bin()
    load_import()


def main():
    parser = argparse.ArgumentParser(description="hello world")
    parser.add_argument("-d", "--directory")
    parser.add_argument("args", nargs="*")
    arguments = parser.parse_args()

    print(arguments.directory)
    print(arguments.args)
    # mvp

    # interactive enter/exit

    # load file shell.env
    # here 

    # bin load hook
    # imports

    # deploy vps

    # shell.py
    # shell.py -- command
    # shell.py target
    # shell.py target -- command
    shell = "/bin/bash"
    print("entering shell")
    load("shell.env")
    code = subprocess.run(shell)
    print("exited shell")
    print(code)


if __name__ == "__main__":
    main()
