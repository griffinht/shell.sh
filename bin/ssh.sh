#!/bin/sh

ssh "${SSH_HOST?}" ${SSH_FLAGS:-} "$@"
