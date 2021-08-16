#!/usr/bin/env bash

## author: KleiberXD

set -e

expected_tpp_solution() {
    local solutionName=${1}
    local solutionDir="${TPP_WORKSPACE}/${solutionName}"
    local solutionConfigFile="${solutionDir}/${SOLUTION_CONFIG_DIR}/${SOLUTION_CONFIG_FILE}"
    local solutionExpected="${solutionDir}/${SOLUTION_EXPECTED_FILE}"

    if ! dirExists ${solutionDir}; then
        echo "Error: '${solutionName}' solution does not exist." >&2
        exit 1
    fi

    if ! fileExists ${solutionExpected}; then
        echo "Error: solution '${solutionFilename}' does not contain the expected.tpp file." >&2
        exit 1
    fi

    # last update
    set_last_update_into_config ${solutionConfigFile} "$(date +"%d-%m-%Y") $(date +"%T")"

    # open source code using vim editor
    vi ${solutionExpected}
}

expected_help() {
    cat <<EOF

Open expected.cpp file into the solution name.

Usage:  tpp expected <solution-name>

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

expected_cmd() {
   if [[ ${#} -ne 1 ]]; then
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
