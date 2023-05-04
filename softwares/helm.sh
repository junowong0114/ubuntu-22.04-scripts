#/bin/bash
set -eo pipefail

# Reference: https://helm.sh/docs/intro/install/
while getopts d:v:u: flag
do
    case "${flag}" in
        d) DIR_PATH=${OPTARG};;
        v) VER_ARG=${OPTARG};;
        u) DEFAULT_HELM_VERSION=${OPTARG};;
    esac
done

if [[ -z "${DIR_PATH}" ]]; then
    echo "Error: Option -d (DIR_PATH) cannot be empty, exiting with status 1"
    exit 1
fi

if [[ -z "${VER_ARG}" ]]; then
    echo "Error: Option -v (HELM_VERSIONS) cannot be empty, exiting with status 1"
    exit 1
fi

print_title.sh "Installing helm"

BINARY_DIR="/opt/helm"
sudo mkdir -p "${BINARY_DIR}"
sudo chown $(id -u):$(id -g) "${BINARY_DIR}"

IFS=',' read -r -a HELM_VERSIONS <<< "${VER_ARG}"
PRIORITY=1
for ver in "${HELM_VERSIONS[@]}"
do
    BINARY_FOLDER=helm-"${ver}"-linux-amd64
    BINARY_FULL_PATH="${BINARY_DIR}"/"${BINARY_FOLDER}"
    EXISTED=$(ls "${BINARY_DIR}" | grep "${BINARY_FOLDER}" || true)
    
    if [[ -z "${EXISTED}" ]]; then
        echo "helm-${ver}-linux-amd64 does not exist, install now with priority $PRIORITY"
        wget -qO- https://get.helm.sh/helm-"${ver}"-linux-amd64.tar.gz | tar zxv -C "${BINARY_DIR}"
        mv "${BINARY_DIR}"/linux-amd64 "${BINARY_FULL_PATH}"
        sudo update-alternatives --install "/usr/local/bin/helm" "helm" "/opt/helm/${BINARY_FOLDER}/helm" $PRIORITY
    else
        echo "helm-${ver}-linux-amd64 already exists, skip installation"
    fi
    ((PRIORITY=PRIORITY + 1))
done

if [[ ! -z "${DEFAULT_HELM_VERSION}" ]]; then
    sudo update-alternatives --set helm /opt/helm/helm-"${DEFAULT_HELM_VERSION}-linux-amd64"/helm
fi
