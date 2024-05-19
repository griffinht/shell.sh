#!/bin/sh

set -xe

shell.sh
shell.sh --
shell.sh sh -c 'exit $CODE'
shell.sh -- sh -c 'exit $CODE'
shell.sh .
shell.sh . --
shell.sh . sh -c 'exit $CODE'
shell.sh . -- sh -c 'exit $CODE'

shell.sh default_exists -- sh -c 'if [ "$BRUH"!= bruh ]; then echo "\$BRUH is wrong: $BRUH" exit $CODE; fi'
shell.sh default_doesnotexist -- true
shell.sh explicit/exists.env -- true
! shell.sh explicit/doesnotexist.env -- true

echo hi
