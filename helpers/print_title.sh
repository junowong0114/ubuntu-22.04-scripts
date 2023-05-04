#!/bin/bash
set -eo pipefail

if [[ -z $1 ]]
then
    echo "You must input a message to print!"
    exit 1
fi

cat << EOF

########################################
$1
########################################
EOF
