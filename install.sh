#!/bin/bash
set -eo pipefail

# Use absolute path
path=$(readlink -f "${BASH_SOURCE:-$0}")
PROJECT_ROOT=$(dirname "$path")
source $PROJECT_ROOT/.env
export PATH="${PATH}:${PROJECT_ROOT}/helpers:${PROJECT_ROOT}/softwares:${PROJECT_ROOT}/runtime"

# install softwares that needs sudo
print_title.sh "Installing/Updating Linux packages"
sudo apt update -qq && sudo apt upgrade -yqq
sudo apt install -yqq jq zip unzip
printf "\nFinished installing/updating Linux packages\n\n"

# install softwares
# PATH=${PATH} nvm.sh -v $NVM_VERSION
npm install --global yarn
PATH=${PATH} aws-cli.sh -d $PROJECT_ROOT
PATH=${PATH} kubectl.sh -d $PROJECT_ROOT -v $KUBECTL_VERSIONS -u $DEFAULT_KUBECTL_VERSION
PATH=${PATH} helm.sh -d $PROJECT_ROOT -v $HELM_VERSIONS -u $DEFAULT_HELM_VERSION
PATH=${PATH} tfenv.sh
PATH=${PATH} k9s.sh -v $K9S_VERSION
PATH=${PATH} pyenv.sh
PATH=${PATH} sdkman.sh
PATH=${PATH} maven.sh -v $MAVEN_VERSION
PATH=${PATH} ansible.sh

# install runtimes
PATH=${PATH} python.sh -v $PYTHON_VERSIONS
PATH=${PATH} java_sdk.sh -v $JAVA_SDK_VERSIONS

# configure git
git config --global user.email "$GIT_USER_EMAIL"
git config --global user.name "$GIT_USER_NAME"

# export path
WIN_HOME_IN_BASHRC=$(cat "${HOME}/.bashrc" | grep "${WIN_HOME}" || true)
if [[ -z "${WIN_HOME_IN_BASHRC}" ]]; then
    echo "export WIN_HOME=${WIN_HOME}" >> $HOME/.bashrc
fi

echo "System initiation completed, please restart the shell now"
