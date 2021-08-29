#!/usr/bin/env bash

## author: KleiberXD

set -e

test_tpp_solution() {
    local solutionName=${1}

    local solutionDir=""
    local solutionFilename=""
    local solutionConfigDir=${SOLUTION_CONFIG_DIR}
    local solutionConfigFile="${SOLUTION_CONFIG_DIR}/${SOLUTION_CONFIG_FILE}"
    local solutionExec=${SOLUTION_BUILD}
    local solutionInput=${SOLUTION_INPUT_FILE}
    local solutionOutput=${SOLUTION_OUTPUT_FILE}
    local solutionExpected=${SOLUTION_EXPECTED_FILE}

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
        solutionOutput="${solutionDir}/${solutionOutput}"
        solutionExpected="${solutionDir}/${solutionExpected}"

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

    if ! fileExists ${solutionFilename}; then
        echo "Error: '$(basename ${solutionFilename%.*})' solution does not contain the cpp file." >&2
        exit 1
    fi

    if isEmpty ${solutionInput}; then
        echo "Error: '$(basename ${solutionFilename%.*})' solution does not contain input data."
        exit 1
    fi

    if isEmpty ${solutionExpected}; then
        echo "Error: '$(basename ${solutionFilename%.*})' solution does not contain expected data."
        exit 1
    fi

    # build cpp file and create executable
    build_cpp_file ${solutionFilename} ${solutionExec}

    # run cpp executable
    run_cpp_file ${solutionFilename} ${solutionExec} ${solutionInput} ${solutionOutput} false

    # test cpp solution and update test status
    test_cpp_file ${solutionFilename} ${solutionOutput} ${solutionExpected} ${solutionConfigFile}

    # get test status
    local testStatus=$(get_test_status_from_config ${solutionConfigFile})
    if [[ ${testStatus} == "Passed" ]]; then
        echo "'$(basename ${solutionFilename})' test PASSED!"
    else
        echo "'$(basename ${solutionFilename})' test FAILED!"
    fi

    # last update
    set_last_update_into_config ${solutionConfigFile} "$(date +"%d-%m-%Y") $(date +"%T")"
}

test_help() {
    cat <<EOF

Compile, run and test the .cpp file into the solution. If the command is run from
within the solution directory, the solution name is an optional argument.

Usage:  tpp test [solution-name]

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

test_cmd() {
    if [[ ${#} -gt 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    local argument=${1}
    case ${argument} in
        --help | -h)
            test_help
            ;;
        *)
            test_tpp_solution ${argument}
            ;;
    esac
}
