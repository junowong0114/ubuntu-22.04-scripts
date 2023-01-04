#!/bin/bash
set -eo pipefail
set -x

# Use absolute path
path=$(readlink -f "${BASH_SOURCE:-$0}")
DIR_PATH=$(dirname "$path")
source $DIR_PATH/.env

# install softwares
$DIR_PATH/softwares/nvm.sh -v $NVM_VERSION
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install node
nvm install lts/hydrogen
nvm alias default lts/hydrogen

# configure git
git config --global user.email "$GIT_USER_EMAIL"
git config --global user.name "$GIT_USER_NAME"
