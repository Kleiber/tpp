#!/usr/bin/env bash

## author: KleiberXD

set -e

set_judge_to_tpp_solution() {
    local judgeName="${1}"
    local name="${2}"

    resolve_solution "${name}"

    # set judge name
    set_judge_name_into_config "${SOL_CONFIG}" "${judgeName}"
}

judge_help() {
    cat <<EOF

Set judge name value to the solution. If the command is run from within the solution
directory, the solution name is an optional argument.

Usage:  tpp judge <judge-name> [solution-name]

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

judge_cmd() {
    if [[ ${#} -gt 2 ]] || [[ ${#} -lt 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    if [[ "${1}" == "--help" ]] || [[ "${1}" == "-h" ]]; then
        judge_help
        exit 0
    fi

    if [[ "${1}" == -* ]] || [[ "${2}" == -* ]]; then
        echo "Error: Invalid flag." >&2
        exit 1
    fi

    local judgeName="${1}"
    local name="${2}"

    set_judge_to_tpp_solution "${judgeName}" "${name}"
}
