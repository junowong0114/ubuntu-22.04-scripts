#!/bin/bash
set -eo pipefail

# Read and check options
while getopts v: flag
do
    case "${flag}" in
        v) VER_ARG=${OPTARG};;
    esac
done

required_option() {
    if [[ ! $3 ]]
    then
        echo "Missing required option $1 ($2)!"
        exit 1
    fi
}
required_option '-v' 'Python version to be installed' ${VER_ARG} 

# Check if pyenv is installed
set +e
command -v pyenv > /dev/null 2>&1
PYTENV_INSTALLED=$?
set -e

if [[ ! ${PYTENV_INSTALLED} == 0 ]]
then
    echo 'pyenv is not installed! Exiting script with status 1'
    exit 1
fi

# Install Pythons
print_title.sh "Installing Python with pyenv"
echo "User input versions: \"${VER_ARG}\""

IFS=',' read -r -a PYTHON_VERSIONS <<< "${VER_ARG}"
for i in "${!PYTHON_VERSIONS[@]}"
do  
    ver="${PYTHON_VERSIONS[$i]}"
    echo "Installing Python version ${ver}"

    # Check if version exists
    set +e
    pyenv install --list | grep ${ver} > /dev/null 2>&1
    if [[ ! $? == 0 ]]
    then
        echo "Python version ${ver} does not exist! Skip installation."
        continue
    fi
    set -e

    # Installation
    pyenv install -v ${ver} --skip-existing
    if [[ $i == 0 ]]
    then
        echo "Set Python ${ver} as default"
        pyenv global ${ver}
    fi
    echo "Installed Python version ${ver}"
done
printf "\nPython installation complete\n"
echo "Installed versions: $(ls -v $HOME/.pyenv/versions/ | tr '\n' ', ')"
echo "Current version: $(python --version)"
echo "Executable path: $(which python)"
