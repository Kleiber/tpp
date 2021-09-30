#!/usr/bin/env bash

## author: KleiberXD

set -e

set_tag_to_tpp_solution() {
    local tagName=${1}
    local solutionName=${2}

    local solutionDir=""
    local solutionConfigDir=${SOLUTION_CONFIG_DIR}
    local solutionConfigFile="${SOLUTION_CONFIG_DIR}/${SOLUTION_CONFIG_FILE}"

    # check if the solution name is an argument
    if [[ ! ${solutionName} ]]; then
        if ! fileExists ${solutionConfigFile}; then
            echo "Error: there is not a solution, tpp config file does not exist." >&2
            exit 1
        fi
    else
        solutionDir="${TPP_WORKSPACE}/${solutionName}"
        solutionConfigDir="${solutionDir}/${solutionConfigDir}"
        solutionConfigFile="${solutionDir}/${solutionConfigFile}"

        if ! dirExists ${solutionDir}; then
            echo "Error: '${solutionName}' solution does not exist." >&2
            exit 1
        fi

        if ! fileExists ${solutionConfigFile}; then
            echo "Error: there is not a solution, tpp config file does not exist." >&2
            exit 1
        fi
    fi

    # set tag name
    set_tag_name_into_config ${solutionConfigFile} ${tagName}
}

tag_help() {
    cat <<EOF

Set tag name value to the solution. If the command is run from within the solution
directory, the solution name is an optional argument.

Usage:  tpp tag <tag-name> [solution-name]

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

tag_cmd() {
    if [[ ${#} -gt 2 ]] || [[ ${#} -lt 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    if [[ ${1} == "--help" ]] || [[ ${1} == "-h" ]]; then
        tag_help
        exit 0
    fi

    if [[ ${1} == -* ]] || [[ ${2} == -* ]]; then
        echo "Error: Invalid flag." >&2
        exit 1
    fi

    local tagName=${1}
    local solutionName=${2}

    set_tag_to_tpp_solution ${tagName} ${solutionName}
}