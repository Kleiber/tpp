#!/usr/bin/env bash

## author: KleiberXD

set -e

open_tpp_solution() {
    local solutionName=${1}
    local solutionDir="${TPP_WORKSPACE}/${solutionName}"
    local solutionConfigDir="${solutionDir}/${SOLUTION_CONFIG_DIR}"
    local solutionConfigFile="${solutionDir}/${SOLUTION_CONFIG_DIR}/${SOLUTION_CONFIG_FILE}"

    if ! dirExists ${solutionDir}; then
        echo "Error: '${solutionName}' solution does not exist." >&2
        exit 1
    fi

    if ! fileExists ${solutionConfigFile}; then
        echo "Error: there is not a solution, tpp config file does not exist." >&2
        exit 1
    fi

    solutionFilename=$(get_name_from_config ${solutionConfigFile})
    solutionFilename="${solutionDir}/${solutionFilename}"

    # last update
    set_last_update_into_config ${solutionConfigFile} "$(date +"%d-%m-%Y") $(date +"%T")"

    # open source code using vim editor
    vi ${solutionFilename}
}

open_help() {
    cat <<EOF

Open .cpp file into the solution name.

Usage:  tpp open <solution-name>

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

open_cmd() {
    if [[ ${#} -ne 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    local argument=${1}
    case ${argument} in
        --help | -h)
            open_help
            ;;
        *)
            open_tpp_solution ${argument}
            ;;
    esac
}