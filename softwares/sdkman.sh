#!/bin/bash
set -eo pipefail

# Use absolute path
SCRIPT_PATH=$(dirname "${BASH_SOURCE:-$0}")
PROJECT_ROOT=$(readlink -f "${SCRIPT_PATH}/..")

if [[ ! -z $(sdk || true) ]]; then
    echo "Already installed SDKMAN!, updating installation"
    sdk update 
fi

${PROJECT_ROOT}/helpers/print_title.sh "Install SDKMAN!"
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
printf "Installed SDKMAN!\n\n"
