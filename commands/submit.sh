#!/usr/bin/env bash

## author: KleiberXD

set -e

submit_tpp_solution() {
    echo "TODO: In progress..!"
}

submit_help() {
    cat <<EOF

Submit solution to github repository. If the command is run from
within the solution directory, the solution name is an optional argument.

Usage:  tpp test [solution-name]

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

submit_cmd() {
    if [[ ${#} -gt 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    local argument=${1}
    case ${argument} in
        --help | -h)
            submit_help
            ;;
        *)
            submit_tpp_solution ${argument}
            ;;
    esac
}