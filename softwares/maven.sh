#!/bin/bash
set -eo pipefail

while getopts v: flag
do
    case "${flag}" in
        v) MAVEN_VERSION=${OPTARG};;
    esac
done

if [[ -z "${MAVEN_VERSION}" ]]; then
    echo "Error: Option -v (MAVEN_VERSION) cannot be empty, exiting with status 1"
    exit 1
fi

# Use absolute path
SCRIPT_PATH=$(dirname "${BASH_SOURCE:-$0}")
PROJECT_ROOT=$(readlink -f "${SCRIPT_PATH}/..")

${PROJECT_ROOT}/helpers/print_title.sh "Install Maven"

BINARY_DIR="/opt/maven"
sudo mkdir -p "${BINARY_DIR}"
sudo chown $(id -u):$(id -g) "${BINARY_DIR}"
BINARY_FOLDER="apache-maven-${MAVEN_VERSION}"
EXISTED=$(ls "${BINARY_DIR}" | grep "${BINARY_FOLDER}" || true)

if [[ -z "${EXISTED}" ]]; then
    echo "${BINARY_FOLDER} does not exist, install now"
    wget -qO- "https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" | tar zx -C "${BINARY_DIR}"
    chown -R 1000:1000 "${BINARY_DIR}/${BINARY_FOLDER}"
else
    echo "${BINARY_FOLDER} already exists, skip installation"
fi

BASH_RC_EXCERPT="export PATH=\"${BINARY_DIR}/${BINARY_FOLDER}/bin:\$PATH\""
BASH_SCRIPT_CONFIGURED=$(cat ~/.bashrc | grep "${BASH_RC_EXCERPT}" || true)

if [[ -z "${BASH_SCRIPT_CONFIGURED}" ]]; then
    cat <<- EOF >> "${HOME}/.bashrc"

# Add Maven to PATH
$BASH_RC_EXCERPT
EOF
    eval "${BASH_RC_EXCERPT}"
fi

${BINARY_DIR}/${BINARY_FOLDER}/bin/mvn --version
