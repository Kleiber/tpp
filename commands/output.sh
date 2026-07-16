#!/usr/bin/env bash

## author: KleiberXD

set -e

output_tpp_solution() {
    local num=${1}
    local name=${2}

    resolve_solution ${name}

    if [[ ! ${num} ]]; then
        num=1
    fi

    local outFile=$(get_output_file "${SOL_DIR}" ${num})

    if ! fileExists "${outFile}"; then
        echo "Error: '$(basename ${SOL_FILENAME%.*})' solution does not contain output file for case ${num}." >&2
        exit 1
    fi

    set_last_update_into_config "${SOL_CONFIG}" "$(date +"%d-%m-%Y") $(date +"%T")"

    ${TPP_IDE} "${outFile}"
}

output_help() {
    cat <<EOF

Open output file for a specific case number. If no number is given, opens case 1.
If the command is run from within the solution directory, the solution name is optional.

Usage:  tpp out [case-number] [solution-name]

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

output_cmd() {
    if [[ ${#} -gt 2 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    if [[ ${1} == "--help" ]] || [[ ${1} == "-h" ]]; then
        output_help
        exit 0
    fi

    if [[ ${1} =~ ^[0-9]+$ ]]; then
        output_tpp_solution ${1} ${2}
    else
        output_tpp_solution "" ${1}
    fi
}
