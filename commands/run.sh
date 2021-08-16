#!/usr/bin/env bash

## author: KleiberXD

set -e

function run_tpp_solution() {
    local solutionName=${1}

    local solutionDir=""
    local solutionFilename=""
    local solutionConfigDir=${SOLUTION_CONFIG_DIR}
    local solutionConfigFile="${SOLUTION_CONFIG_DIR}/${SOLUTION_CONFIG_FILE}"
    local solutionExec=${SOLUTION_BUILD}
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
        solutionExec="${solutionDir}/${solutionExec}"
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

    # build cpp file and create executable
    build_cpp_file ${solutionFilename} ${solutionExec}

    # run cpp executable
    run_cpp_file ${solutionFilename} ${solutionExec} ${solutionInput} "" true

    # last update
    set_last_update_into_config ${solutionConfigFile} "$(date +"%d-%m-%Y") $(date +"%T")"
}

run_help() {
    cat <<EOF

Compile and run the .cpp file into the solution. If the command is run from within
the solution directory, the solution name is an optional argument.

Usage:  tpp run [solution-name]

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

run_cmd() {
    if [[ ${#} -gt 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    local argument=${1}
    case ${argument} in
        --help | -h)
            run_help
            ;;
        *)
            run_tpp_solution ${argument}
            ;;
    esac
}
