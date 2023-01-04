#!/bin/bash
set -eo pipefail

# Elevate to superuser
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

# fetch distro upgrade
apt-get update && apt-get upgrade
