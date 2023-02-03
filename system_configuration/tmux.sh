#!/bin/bash
set -eo pipefail

path=$(readlink -f "${BASH_SOURCE:-$0}")
DIR_PATH=$(dirname "$path")

cp "${DIR_PATH}/tmux/.tmux.conf" $HOME

ALIAS_SET=$(cat $HOME/.bashrc | grep "tmux=\"TERM=xterm-256color tmux\"" || true)
if [[ ! $ALIAS_SET ]]; then
    echo "alias tmux=\"TERM=xterm-256color tmux\"" >> "${HOME}/.bashrc"
fi;
