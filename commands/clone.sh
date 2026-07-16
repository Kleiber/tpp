#!/usr/bin/env bash

## author: KleiberXD

set -e

clone_tpp_solution() {
    local source="${1}"
    local target="${2}"

    if [[ ! "${source}" ]] || [[ ! "${target}" ]]; then
        echo "Error: source and target names are required." >&2
        exit 1
    fi

    if ! isValidName "${target}"; then
        echo "Error: invalid solution name '${target}'." >&2
        exit 1
    fi

    local sourceDir="${TPP_WORKSPACE}/${source}"
    local targetDir="${TPP_WORKSPACE}/${target}"

    if ! dirExists "${sourceDir}"; then
        echo "Error: '${source}' solution does not exist." >&2
        exit 1
    fi

    if dirExists "${targetDir}"; then
        echo "Error: '${target}' solution already exists." >&2
        exit 1
    fi

    cp -r "${sourceDir}" "${targetDir}"

    local sourceCpp="${targetDir}/${source}.${EXTENSION_FILE}"
    local targetCpp="${targetDir}/${target}.${EXTENSION_FILE}"
    if fileExists "${sourceCpp}"; then
        mv "${sourceCpp}" "${targetCpp}"
    fi

    # Don't carry over old ready file or build binary
    local sourceReady="${targetDir}/${source}_ready.${EXTENSION_FILE}"
    if fileExists "${sourceReady}"; then
        rm "${sourceReady}"
    fi

    local buildFile="${targetDir}/${BUILD}"
    if fileExists "${buildFile}"; then
        rm "${buildFile}"
    fi

    local configFile="${targetDir}/${CONFIG_DIR}/${CONFIG_FILE}"
    local judge=$(get_judge_name_from_config "${configFile}")
    local tag=$(get_tag_name_from_config "${configFile}")

    write_config "${configFile}" "${target}.${EXTENSION_FILE}" "$(date +"%d-%m-%Y %H:%M:%S")" "${judge}" "${tag}" "$(date +"%d-%m-%Y %H:%M:%S")" "Pending"

    echo "'${source}' cloned to '${target}' successfully!"
}

clone_help() {
    cat <<EOF

Clone an existing solution as a starting point for a new one.

Usage:  tpp clone <source-name> <target-name>

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

clone_cmd() {
    if [[ ${#} -gt 2 ]] || [[ ${#} -lt 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    if [[ "${1}" == "--help" ]] || [[ "${1}" == "-h" ]]; then
        clone_help
        exit 0
    fi

    clone_tpp_solution "${1}" "${2}"
}
