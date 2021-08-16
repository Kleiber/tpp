#!/usr/bin/env bash

## author: KleiberXD

set -e

output_tpp_solution() {
    local solutionName=${1}
    local solutionDir="${TPP_WORKSPACE}/${solutionName}"
    local solutionConfigFile="${solutionDir}/${SOLUTION_CONFIG_DIR}/${SOLUTION_CONFIG_FILE}"
    local solutionOutput="${solutionDir}/${SOLUTION_OUTPUT_FILE}"

    if ! dirExists ${solutionDir}; then
        echo "Error: '${solutionName}' solution does not exist." >&2
        exit 1
    fi

    if ! fileExists ${solutionOutput}; then
        echo "Error: solution '${solutionFilename}' does not contain the out.tpp file." >&2
        exit 1
    fi

    # last update
    set_last_update_into_config ${solutionConfigFile} "$(date +"%d-%m-%Y") $(date +"%T")"

    # open source code using vim editor
    vi ${solutionOutput}
}

output_help() {
    cat <<EOF

Open out.cpp file into the solution name.

Usage:  tpp output <solution-name>

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

output_cmd() {
   if [[ ${#} -ne 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    local argument=${1}
    case ${argument} in
        --help | -h)
            output_help
            ;;
        *)
            output_tpp_solution ${argument}
            ;;
    esac
}
