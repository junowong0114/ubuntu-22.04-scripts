#/bin/bash
set -eo pipefail

INSTALLED=$(command -v tfenv || true)
if [[ ! -z "${INSTALLED}" ]]; then
    echo "tfenv version $(tfenv -v) is already installed, update now"
    git -C ~/.tfenv pull
    echo "tfenv is now at $(tfenv -v)"
else
    git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv

    BASH_RC_EXCERPT='export PATH="$HOME/.tfenv/bin:$PATH"'
    BASH_SCRIPT_CONFIGURED=$(cat ~/.bashrc/ | grep "${BASH_RC_EXCERPT}" || true)

    if [[ -z "${BASH_SCRIPT_CONFIGURED}" ]]; then
        echo "${BASH_RC_EXCERPT}" >> ~/.bashrc
        eval "${BASH_RC_EXCERPT}"
    fi

    echo "Installed tfenv version $(tfenv -v)"
fi

$HOME/.tfenv/bin/tfenv install latest
$HOME/.tfenv/bin/tfenv use latest
