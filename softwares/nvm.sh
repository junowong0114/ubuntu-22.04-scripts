#/bin/bash

while getopts v: flag
do
    case "${flag}" in
        v) NVM_VERSION=${OPTARG};;
    esac
done

curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash
