#/bin/bash
set -eo pipefail

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

# install
TMP_DIR="${DIR_PATH}/tmp"
mkdir -p "${TMP_DIR}"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "${TMP_DIR}/awscliv2.zip"
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
