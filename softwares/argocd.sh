#/bin/bash
set -eo pipefail

# Reference: https://argo-cd.readthedocs.io/en/stable/cli_installation/
while getopts d: flag
do
    case "${flag}" in
        d) DIR_PATH=${OPTARG};;
    esac
done

if [[ -z "${DIR_PATH}" ]]; then
    echo "Error: Option -d (DIR_PATH) cannot be empty, exiting with status 1"
    exit 1
fi

# create tmp directory for downloading argocd cli
TMP_DIR="${DIR_PATH}/tmp"
mkdir -p "${TMP_DIR}"

# install
curl -sSL -o "${TMP_DIR}/argocd-linux-amd64" https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 "${TMP_DIR}/argocd-linux-amd64" /usr/bin/argocd
echo "Installed ArgoCD CLI version"
argocd version

# cleanup
rm -rf "${TMP_DIR}"
