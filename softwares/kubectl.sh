#/bin/bash
set -eo pipefail

# Reference: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux
while getopts d:v:u: flag
do
    case "${flag}" in
        d) DIR_PATH=${OPTARG};;
        v) VER_ARG=${OPTARG};;
        u) DEFAULT_KUBECTL_VERSION=${OPTARG};;
    esac
done

if [[ -z "${DIR_PATH}" ]]; then
    echo "Error: Option -d (DIR_PATH) cannot be empty, exiting with status 1"
    exit 1
fi

if [[ -z "${VER_ARG}" ]]; then
    echo "Error: Option -v (KUBECTL_VERSIONS) cannot be empty, exiting with status 1"
    exit 1
fi

BINARY_DIR="/opt/kubectl"
sudo mkdir -p "${BINARY_DIR}"
sudo chown $(id -u):$(id -g) "${BINARY_DIR}"

IFS=',' read -r -a KUBECTL_VERSIONS <<< "${VER_ARG}"
PRIORITY=1
for ver in "${KUBECTL_VERSIONS[@]}"
do
    BINARY_FOLDER=kubectl-"${ver}"
    BINARY_FULL_PATH="${BINARY_DIR}"/"${BINARY_FOLDER}"
    EXISTED=$(ls "${BINARY_DIR}" | grep "${BINARY_FOLDER}" || true)
    
    if [[ -z "${EXISTED}" ]]; then
        echo "kubectl-${ver} does not exist, install now with priority $PRIORITY"
        mkdir -p "${BINARY_FULL_PATH}"
        curl -L -o "${BINARY_FULL_PATH}"/kubectl "https://dl.k8s.io/release/${ver}/bin/linux/amd64/kubectl"
        sudo update-alternatives --install "/usr/local/bin/kubectl" "kubectl" "/opt/kubectl/kubectl-${ver}/kubectl" $PRIORITY
    else
        echo "kubectl-${ver} already exists, skip installation"
    fi
    ((PRIORITY=PRIORITY + 1))
done

# +x to kubectl binaries
find "${BINARY_DIR}" -type f -name "kubectl" -print0 | xargs -0 chmod +x

if [[ ! -z "${DEFAULT_KUBECTL_VERSION}" ]]; then
    sudo update-alternatives --set kubectl /opt/kubectl/kubectl-"${DEFAULT_KUBECTL_VERSION}"/kubectl
fi
