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
required_option '-v' 'Java SDK version to be installed' ${VER_ARG} 

# Check if SDKMAN! is installed
set +e
find ${HOME}/.sdkman/bin/sdkman-init.sh -type f > /dev/null
SDKMAN_INSTALLED=$?
set -e

if [[ ! ${SDKMAN_INSTALLED} == 0 ]]
then
    echo 'SDKMAN! is not installed! Exiting script with status 1'
    exit 1
fi

# Use absolute path
SCRIPT_PATH=$(dirname "${BASH_SOURCE:-$0}")
PROJECT_ROOT=$(readlink -f "${SCRIPT_PATH}/..")

# init SDKMAN
source "${HOME}/.sdkman/bin/sdkman-init.sh"

# Install Java SDKs
${PROJECT_ROOT}/helpers/print_title.sh "Install Java SDK with SDKMAN!"
echo "User input versions: \"${VER_ARG}\""

IFS=',' read -r -a JAVA_SDK_VERSIONS <<< "${VER_ARG}"
for i in "${!JAVA_SDK_VERSIONS[@]}"
do
    ver="${JAVA_SDK_VERSIONS[$i]}"
    echo "Installing Java SDK version ${ver}"

    # Check if version exists
    set +e
    sdk list java | grep ${ver} > /dev/null 2>&1
    if [[ ! $? == 0 ]]
    then
        echo "Java SDK version ${ver} does not exist! Skip installation."
        continue
    fi
    set -e

    # Installation
    sdk install java ${ver}
    if [[ $i == 0 ]]
    then
        echo "Set Java SDK ${ver} as default"
        sdk default java ${ver}
    fi
    echo "Installed Java SDK version ${ver}"
done
printf "\nJava SDK installation complete\n"
echo "Installed versions: $(ls -v $HOME/.sdkman/candidates/java | tr '\n' ',' | perl -pe 's|(.*),current,?(.*)?|\1\2|')"
echo "Current version: $(sdk current java | tr -d '\n' | sed 's|Using java version\s||')"
