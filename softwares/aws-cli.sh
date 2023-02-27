#/bin/bash
set -eo pipefail

while getopts d: flag
do
    case "${flag}" in
        d) PROJECT_ROOT=${OPTARG};;
    esac
done

if [[ -z "${PROJECT_ROOT}" ]]; then
    echo "Error: Option -d (PROJECT_ROOT) cannot be empty, exiting with status 1"
    exit 1
fi

print_title.sh "Installing AWS cli"

# install
TMP_DIR="${PROJECT_ROOT}/tmp"
mkdir -p "${TMP_DIR}"
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "${TMP_DIR}/awscliv2.zip"
unzip -q "${TMP_DIR}/awscliv2.zip" -d "${TMP_DIR}"

AWS_BIN=$(command -v aws || true)
if [[ -z "${AWS_BIN}" ]]; then
    sudo "${TMP_DIR}"/aws/install
else
    sudo "${TMP_DIR}"/aws/install --update
fi

# cleanup
rm -rf "${TMP_DIR}"

# configure aws
aws configure
