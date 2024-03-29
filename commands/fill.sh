#!/usr/bin/env bash

## author: KleiberXD

set -e

fill_tpp_solution() {
    local solutionName=${1}

    local solutionDir=""
    local solutionFilename=""
    local solutionConfigDir=${SOLUTION_CONFIG_DIR}
    local solutionConfigFile="${SOLUTION_CONFIG_DIR}/${SOLUTION_CONFIG_FILE}"

    # check if the solution name is an argument
    if [[ ! ${solutionName} ]]; then
        if ! fileExists ${solutionConfigFile}; then
            echo "Error: there is not a solution, tpp config file does not exist." >&2
            exit 1
        fi

        solutionFilename=$(get_name_from_config ${solutionConfigFile})
        solutionName=$(echo $solutionFilename | cut -d '.' -f 1)
        solutionDir="${HOME}/${TPP_WORKSPACE}/${solutionName}"
    else
        solutionDir="${HOME}/${TPP_WORKSPACE}/${solutionName}"
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

        solutionFilename=$(get_name_from_config ${solutionConfigFile})
    fi

    if ! fileExists ${solutionDir}/${solutionFilename}; then
        echo "Error: '$(basename ${solutionFilename%.*})' solution does not contain the cpp file." >&2
        exit 1
    fi

    # last update
    set_last_update_into_config ${solutionConfigFile} "$(date +"%d-%m-%Y") $(date +"%T")"

    # fill input/outpu data
    codeforces="${HOME}/tpp/wrapper/codeforces.py"
    python3 $codeforces $solutionFilename $solutionDir $SOLUTION_INPUT_FILE $SOLUTION_EXPECTED_FILE

}

fill_help() {
    cat <<EOF

Fill the in.tpp and exp.tpp files with the input/output data into the solution name. 
If the command is run from within the solution directory, the solution name is 
an optional argument.

Currently only available for Codeforces judge!

Usage:  tpp fill [solution-name]

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

fill_cmd() {
    if [[ ${#} -gt 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    local argument=${1}
    case ${argument} in
        --help | -h)
            fill_help
            ;;
        *)
            fill_tpp_solution ${argument}
            ;;
    esac
}