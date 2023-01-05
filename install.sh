#!/bin/bash
set -eo pipefail

# Use absolute path
path=$(readlink -f "${BASH_SOURCE:-$0}")
DIR_PATH=$(dirname "$path")
source $DIR_PATH/.env

# install softwares that needs sudo
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install zip unzip

# install softwares
$DIR_PATH/softwares/nvm.sh -v $NVM_VERSION
$DIR_PATH/softwares/aws-cli.sh -d $DIR_PATH

# configure git
git config --global user.email "$GIT_USER_EMAIL"
git config --global user.name "$GIT_USER_NAME"
