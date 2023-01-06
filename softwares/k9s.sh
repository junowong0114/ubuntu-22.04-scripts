#/bin/bash
set -eo pipefail

while getopts v: flag
do
    case "${flag}" in
        v) K9S_VERSION=${OPTARG};;
    esac
done

if [[ -z "${K9S_VERSION}" ]]; then
    echo "Error: Option -v (K9S_VERSION) cannot be empty, exiting with status 1"
    exit 1
fi

BINARY_DIR="/opt/k9s"
sudo mkdir -p "${BINARY_DIR}"
sudo chown $(id -u):$(id -g) "${BINARY_DIR}"
BINARY_FOLDER=k9s-"${K9S_VERSION}"
BINARY_FULL_PATH="${BINARY_DIR}"/"${BINARY_FOLDER}"
EXISTED=$(ls "${BINARY_DIR}" | grep "${BINARY_FOLDER}" || true)

if [[ -z "${EXISTED}" ]]; then
    echo "k9s-${K9S_VERSION} does not exist, install now"
    mkdir -p "${BINARY_FULL_PATH}"
    wget -qO- "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_x86_64.tar.gz" | tar zxv -C "${BINARY_FULL_PATH}"
else
    echo "k9s-${K9S_VERSION} already exists, skip installation"
fi

BASH_RC_EXCERPT="export PATH=\"${BINARY_FULL_PATH}:\$PATH\""
BASH_SCRIPT_CONFIGURED=$(cat ~/.bashrc | grep "${BASH_RC_EXCERPT}" || true)

if [[ -z "${BASH_SCRIPT_CONFIGURED}" ]]; then
    echo "${BASH_RC_EXCERPT}" >> ~/.bashrc
    eval "${BASH_RC_EXCERPT}"
fi

"${BINARY_FULL_PATH}"/k9s version
