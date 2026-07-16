#!/usr/bin/env bash

## author: KleiberXD

set -e

input_tpp_solution() {
    local num=${1}
    local name=${2}

    resolve_solution ${name}

    if [[ ! ${num} ]]; then
        num=1
    fi

    local inFile=$(get_input_file "${SOL_DIR}" ${num})

    # create if doesn't exist
    touch "${inFile}"

    set_last_update_into_config "${SOL_CONFIG}" "$(date +"%d-%m-%Y") $(date +"%T")"

    ${TPP_IDE} "${inFile}"
}

input_help() {
    cat <<EOF

Open input file for a specific case number. If no number is given, opens case 1.
If the command is run from within the solution directory, the solution name is optional.

Usage:  tpp in [case-number] [solution-name]

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

input_cmd() {
    if [[ ${#} -gt 2 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    if [[ ${1} == "--help" ]] || [[ ${1} == "-h" ]]; then
        input_help
        exit 0
    fi

    # determine if first arg is a number or solution name
    if [[ ${1} =~ ^[0-9]+$ ]]; then
        input_tpp_solution ${1} ${2}
    else
        input_tpp_solution "" ${1}
    fi
}
