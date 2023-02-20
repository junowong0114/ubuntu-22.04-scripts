#!/bin/bash
set -eo pipefail

# Use absolute path
path=$(readlink -f "${BASH_SOURCE:-$0}")
DIR_PATH=$(dirname "$path")
source $DIR_PATH/.env

# install softwares that needs sudo
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install zip unzip
sudo apt-get install jq

# install softwares
$DIR_PATH/softwares/nvm.sh -v $NVM_VERSION
npm install --global yarn
$DIR_PATH/softwares/aws-cli.sh -d $DIR_PATH
$DIR_PATH/softwares/kubectl.sh -d $DIR_PATH -v $KUBECTL_VERSIONS -u $DEFAULT_KUBECTL_VERSION
$DIR_PATH/softwares/helm.sh -d $DIR_PATH -v $HELM_VERSIONS -u $DEFAULT_HELM_VERSION
$DIR_PATH/softwares/tfenv.sh
$DIR_PATH/softwares/k9s.sh -v $K9S_VERSION
$DIR_PATH/softwares/pyenv.sh
$DIR_PATH/runtime/python.sh -v $PYTHON_VERSIONS
# $DIR_PATH/softwares/argocd.sh -d $DIR_PATH

# configure git
git config --global user.email "$GIT_USER_EMAIL"
git config --global user.name "$GIT_USER_NAME"

# export path
WIN_HOME_IN_BASHRC=$(cat "${HOME}/.bashrc" | grep "${WIN_HOME}" || true)
if [[ -z "${WIN_HOME_IN_BASHRC}" ]]; then
    echo "export WIN_HOME=${WIN_HOME}" >> $HOME/.bashrc
fi

echo "System initiation completed, please restart the shell now"
