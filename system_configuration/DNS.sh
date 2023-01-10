#!/bin/bash
set -eo pipefail

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

echo 'Configure DNS Server'
cat <<EOT > /etc/wsl.conf
[network]
generateResolvConf = false
EOT

cat <<EOT > /etc/resolv.conf
nameserver 10.0.10.66
nameserver 10.10.8.93
search hktdc.org
EOT
