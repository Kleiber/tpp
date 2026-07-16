#!/usr/bin/env bash

## author: KleiberXD

set -e

expected_tpp_solution() {
    local name=${1}

    resolve_solution ${name}

    if ! fileExists "${SOL_EXP}"; then
        echo "Error: '$(basename ${SOL_FILENAME%.*})' solution does not contain the expected file." >&2
        exit 1
    fi

    # last update
    set_last_update_into_config "${SOL_CONFIG}" "$(date +"%d-%m-%Y") $(date +"%T")"

    # open source code using vim editor
    ${TPP_IDE} "${SOL_EXP}"
}

expected_help() {
    cat <<EOF

Open exp.tpp file into the solution name. If the command is run from within the
solution directory, the solution name is an optional argument.

Usage:  tpp exp [solution-name]

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

expected_cmd() {
   if [[ ${#} -gt 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    local argument=${1}
    case ${argument} in
        --help | -h)
            expected_help
            ;;
        *)
            expected_tpp_solution ${argument}
            ;;
    esac
}
