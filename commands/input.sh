#!/usr/bin/env bash

## author: KleiberXD

set -e

input_tpp_solution() {
    local solutionName=${1}
    local solutionDir="${TPP_WORKSPACE}/${solutionName}"
    local solutionInput="${solutionDir}/${SOLUTION_INPUT_FILE}"

    if ! dirExists ${solutionDir}; then
        echo "Error: '${solutionName}' solution does not exist." >&2
        exit 1
    fi

    if ! fileExists ${solutionInput}; then
        echo "Error: solution '${solutionFilename}' does not contain the in.tpp file." >&2
        exit 1
    fi

    # last update
    set_last_update_into_config ${solutionConfigFile} "$(date +"%d-%m-%Y") $(date +"%T")"

    # open source code using vim editor
    vi ${solutionInput}
}

input_help() {
    cat <<EOF

Open in.cpp file into the solution name.

Usage:  tpp input <solution-name>

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

input_cmd() {
   if [[ ${#} -ne 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    local argument=${1}
    case ${argument} in
        --help | -h)
            input_help
            ;;
        *)
            input_tpp_solution ${argument}
            ;;
    esac
}
