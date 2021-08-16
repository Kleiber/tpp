#!/usr/bin/env bash

## author: KleiberXD

set -e

input_tpp_solution() {
    local solutionName=${1}

    local solutionDir=""
    local solutionFilename=""
    local solutionConfigDir=${SOLUTION_CONFIG_DIR}
    local solutionConfigFile="${SOLUTION_CONFIG_DIR}/${SOLUTION_CONFIG_FILE}"
    local solutionInput=${SOLUTION_INPUT_FILE}

    # check if the solution name is an argument
    if [[ ! ${solutionName} ]]; then
        if ! fileExists ${solutionConfigFile}; then
            echo "Error: there is not a solution, tpp config file does not exist." >&2
            exit 1
        fi

        solutionFilename=$(get_name_from_config ${solutionConfigFile})
    else
        solutionDir="${TPP_WORKSPACE}/${solutionName}"
        solutionConfigDir="${solutionDir}/${solutionConfigDir}"
        solutionConfigFile="${solutionDir}/${solutionConfigFile}"
        solutionInput="${solutionDir}/${solutionInput}"

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
    fi

    if ! fileExists ${solutionInput}; then
        echo "Error: '$(basename ${solutionFilename%.*})' solution does not contain the input file." >&2
        exit 1
    fi

    # last update
    set_last_update_into_config ${solutionConfigFile} "$(date +"%d-%m-%Y") $(date +"%T")"

    # open source code using vim editor
    vi ${solutionInput}
}

input_help() {
    cat <<EOF

Open in.tpp file into the solution name. If the command is run from within the
solution directory, the solution name is an optional argument.

Usage:  tpp in [solution-name]

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

input_cmd() {
   if [[ ${#} -gt 1 ]]; then
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
