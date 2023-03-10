#/bin/bash
set -eo pipefail

# Use absolute path
SCRIPT_PATH=$(dirname "${BASH_SOURCE:-$0}")
PROJECT_ROOT=$(readlink -f "${SCRIPT_PATH}/..")

TARGETS=$(find "$PROJECT_ROOT" -type f -name "*.sh" -print0 | xargs -0 stat -c "%a %n" | (grep -v "755" || true) | awk '{ print $2 }')
if [[ ! -z "${TARGETS}" ]]; then
    echo "Found non-755 scripts:"
    echo "${TARGETS}"
    echo "${TARGETS}" | xargs chmod +x
    printf "Changed mode to 755\n\n"
else
    printf "Found no non-755 scripts\n\n"
fi

echo "All scripts:"
find "${PROJECT_ROOT}" -type f -name "*.sh" -print0 | xargs -0 stat -c "%a %n"
