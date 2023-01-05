#/bin/bash
set -eo pipefail

while getopts v: flag
do
    case "${flag}" in
        v) NVM_VERSION=${OPTARG};;
    esac
done

# install
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash

# install node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install lts/hydrogen
nvm alias default lts/hydrogen
