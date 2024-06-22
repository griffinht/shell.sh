#!/bin/sh

echo '' | fzf --preview "${1?} {q} < ${2?}"
