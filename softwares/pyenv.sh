#!/bin/bash
set -eo pipefail

echo "Installing pyenv and python..."

# reference: https://realpython.com/intro-to-pyenv/
echo "Installing dependencies for building python from source..."
sudo apt-get -qq install -y \
make \
build-essential \
libssl-dev \
zlib1g-dev \
libbz2-dev \
libreadline-dev \
libsqlite3-dev \
wget \
curl \
llvm \
libncurses5-dev \
libncursesw5-dev \
xz-utils \
tk-dev \
libffi-dev \
liblzma-dev \
python-openssl

echo "Runnning the pyenv installation script..."
if [[ -d "${HOME}/.pyenv" ]]
then
    echo "pyenv is already installed, skip installation"
    exit 0
else
    echo "Installing pyenv..."
    curl -sS https://pyenv.run | bash > /dev/null 2>&1 
fi

find_string() {
    cat "$1" | grep "$2"
}

set +e
find_string "${HOME}/.bashrc" 'export PYENV_ROOT="$HOME/.pyenv"'
BASHRC_INITED=$?
find_string "${HOME}/.profile" 'export PYENV_ROOT="$HOME/.pyenv"'
PROFILE_INITED=$?
set -e

if [[ ! ${BASHRC_INITED} == 0 ]]
then
echo "Writing init scripts to \"${HOME}/.bashrc...\""
cat <<- 'EOF' >> "${HOME}/.bashrc"

# set up pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
EOF
fi

if [[ ! ${PROFILE_INITED} == 0 ]]
then
echo "Writing init scripts to \"${HOME}/.profile...\""
cat <<- 'EOF' >> "${HOME}/.profile"

# set up pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
EOF
fi

echo "Finished installing pyenv"
