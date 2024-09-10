#!/usr/bin/env bash

## author: KleiberXD

set -e

function init_tpp_solution() {
    local name=${1}
    local dir="${TPP_WORKSPACE}/${name}"
    local configDir="${dir}/${CONFIG_DIR}"

    if isValidName ${name}; then
        echo "Error: invalid solution name '${name}'." >&2
        exit 1
    fi

    if dirExists ${dir}; then
        echo "Error: '${name}' solution already exists." >&2
        exit 1
    fi

    # create solution and tpp config directories
    mkdir -p "${dir}" "${configDir}"

    # create input, output and expected tpp files
    touch "${dir}/${INPUT_FILE}" "${dir}/${OUTPUT_FILE}" "${dir}/${EXPECTED_FILE}"

    # create tpp config file
    local configFile="${configDir}/${CONFIG_FILE}"
    local filename="${name}.${EXTENSION_FILE}"

    config_template ${filename} ${configFile}

    # define reference to debug.h
    local debugRefPath=${TPP_DIR}

    if isWindows; then
        local partition="${debugRefPath:1:1}"
        debugRefPath="${partition^}:${debugRefPath:2}"
    fi

    # generate cpp template file
    if isMac; then
        mac_os_template ${dir} ${filename} ${debugRefPath}
    else
        linux_os_template ${dir} ${filename} ${debugRefPath}
    fi

    # try to fill samples inputs and outputs
    if [[ ${TPP_FILL} == "1" ]]; then
        echo "Loading samples inputs/outputs..."
        python3 -W ignore ${TPP_DIR}/codeforces/codeforces.py ${name} ${INPUT_FILE} ${EXPECTED_FILE} ${dir}
    fi

    echo "'${name}' solution was initialized successfully!"
}

init_help() {
    cat <<EOF

Init a new solution with the specified name in the workspace.

Usage:  tpp init <solution-name>

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

init_cmd() {
    if [[ ${#} -gt 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    local argument=${1}
    case ${argument} in
        --help | -h)
            init_help
            ;;
        *)
            init_tpp_solution ${argument}
            ;;
    esac
}
