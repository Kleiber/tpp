#!/usr/bin/env bash

## tpp install script

set -e

TPP_DIR="$(cd "$(dirname "${BASH_SOURCE-$0}")" && pwd)"
VERSION=$(cat "${TPP_DIR}/config/VERSION")

setup_color() {
    if [ -t 1 ]; then
        FMT_C1=$(printf '\033[38;5;51m')
        FMT_C2=$(printf '\033[38;5;39m')
        FMT_C3=$(printf '\033[38;5;33m')
        FMT_C4=$(printf '\033[38;5;27m')
        FMT_GREEN=$(printf '\033[32m')
        FMT_YELLOW=$(printf '\033[33m')
        FMT_CYAN=$(printf '\033[36m')
        FMT_BOLD=$(printf '\033[1m')
        FMT_DIM=$(printf '\033[2m')
        FMT_RESET=$(printf '\033[0m')
    else
        FMT_C1="" FMT_C2="" FMT_C3="" FMT_C4=""
        FMT_GREEN="" FMT_YELLOW="" FMT_CYAN="" FMT_BOLD="" FMT_DIM="" FMT_RESET=""
    fi
}

print_banner() {
    printf '\n'
    printf '%s   __              %s\n' "${FMT_C1}" "${FMT_RESET}"
    printf '%s  / /_ ____  ____ %s\n' "${FMT_C1}" "${FMT_RESET}"
    printf '%s / __// __ \\/ __ \\%s\n' "${FMT_C1}" "${FMT_RESET}"
    printf '%s/ /_ / /_/ / /_/ /%s\n' "${FMT_C1}" "${FMT_RESET}"
    printf '%s\\__/ / .___/.___/ %s\n' "${FMT_C1}" "${FMT_RESET}"
    printf '%s     /_/   /_/    %s%s%s\n' "${FMT_C1}" "${FMT_DIM}" "${VERSION}" "${FMT_RESET}"
    printf '\n'
    printf '  %s%sCompetitive Programming Tool%s\n' "${FMT_BOLD}" "${FMT_C1}" "${FMT_RESET}"
    printf '\n'
}

setup_color
print_banner

if [[ -f "${HOME}/.zshrc" ]]; then
    SHELL_RC="${HOME}/.zshrc"
    SHELL_NAME="zsh"
elif [[ -f "${HOME}/.bashrc" ]]; then
    SHELL_RC="${HOME}/.bashrc"
    SHELL_NAME="bash"
else
    SHELL_RC="${HOME}/.bashrc"
    SHELL_NAME="bash"
fi
echo -e "  ${FMT_GREEN}✓${FMT_RESET} Shell detected: ${SHELL_NAME}"

if command -v g++ &>/dev/null; then
    GCC_VER=$(g++ -dumpversion 2>/dev/null || g++ --version | head -1)
    echo -e "  ${FMT_GREEN}✓${FMT_RESET} Compiler: g++ (${GCC_VER})"
else
    echo -e "  ${FMT_YELLOW}⚠${FMT_RESET} g++ not found — install a C++ compiler"
fi

if command -v python3 &>/dev/null; then
    PY_VER=$(python3 --version 2>&1 | cut -d' ' -f2)
    echo -e "  ${FMT_GREEN}✓${FMT_RESET} Python3: ${PY_VER}"
else
    echo -e "  ${FMT_YELLOW}⚠${FMT_RESET} python3 not found — auto-fill won't work"
fi

PROFILE_LINE="source ${TPP_DIR}/tpp.profile"

if grep -q "tpp.profile" "${SHELL_RC}" 2>/dev/null; then
    echo -e "  ${FMT_GREEN}✓${FMT_RESET} Already in ~/${SHELL_RC##*/}"
else
    echo "" >> "${SHELL_RC}"
    echo "# tpp - competitive programming tool" >> "${SHELL_RC}"
    echo "${PROFILE_LINE}" >> "${SHELL_RC}"
    echo -e "  ${FMT_GREEN}✓${FMT_RESET} Source added to ~/${SHELL_RC##*/}"
fi

(set +e; source "${TPP_DIR}/tpp.profile") 2>/dev/null
export TPP_WORKSPACE="${TPP_WORKSPACE:-$HOME/code}"
mkdir -p "${TPP_WORKSPACE}"
echo -e "  ${FMT_GREEN}✓${FMT_RESET} Workspace: ${TPP_WORKSPACE}"

printf '\n'
printf '  %s%sReady!%s Run: %ssource ~/%s%s\n' "${FMT_BOLD}" "${FMT_GREEN}" "${FMT_RESET}" "${FMT_CYAN}" "${SHELL_RC##*/}" "${FMT_RESET}"
printf '\n'
printf '  Quick start:\n'
printf '    %sinit 1950A%s        Create a solution\n' "${FMT_BOLD}" "${FMT_RESET}"
printf '    %sopen 1950A%s        Open in editor\n' "${FMT_BOLD}" "${FMT_RESET}"
printf '    %stest 1950A%s        Run test cases\n' "${FMT_BOLD}" "${FMT_RESET}"
printf '    %sprepare 1950A%s     Generate submission\n' "${FMT_BOLD}" "${FMT_RESET}"
printf '\n'
printf '  %sDocs: https://github.com/Kleiber/tpp%s\n' "${FMT_DIM}" "${FMT_RESET}"
printf '\n'
