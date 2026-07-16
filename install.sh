#!/usr/bin/env bash

## tpp install script

set -e

TPP_DIR="$(cd "$(dirname "${BASH_SOURCE-$0}")" && pwd)"
PROFILE_LINE="source ${TPP_DIR}/tpp.profile"

# detect shell config file
if [[ -f "${HOME}/.zshrc" ]]; then
    SHELL_RC="${HOME}/.zshrc"
elif [[ -f "${HOME}/.bashrc" ]]; then
    SHELL_RC="${HOME}/.bashrc"
else
    SHELL_RC="${HOME}/.bashrc"
fi

# check if already installed
if grep -q "tpp.profile" "${SHELL_RC}" 2>/dev/null; then
    echo "tpp is already installed in ${SHELL_RC}"
    exit 0
fi

# append source line
echo "" >> "${SHELL_RC}"
echo "# tpp - competitive programming tool" >> "${SHELL_RC}"
echo "${PROFILE_LINE}" >> "${SHELL_RC}"

# create workspace
source "${TPP_DIR}/tpp.profile"
mkdir -p "${TPP_WORKSPACE}"

echo "tpp installed successfully!"
echo ""
echo "  Shell config: ${SHELL_RC}"
echo "  Workspace:    ${TPP_WORKSPACE}"
echo ""
echo "Run: source ${SHELL_RC}"
