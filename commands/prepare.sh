#!/usr/bin/env bash

## author: KleiberXD

set -e

# prepate file to submission by cleaning debug reference and its usage
function prepare_tpp_solution() {
    local name=${1}

    resolve_solution ${name}

    if ! fileExists "${SOL_FILENAME}"; then
        echo "Error: '$(basename ${SOL_FILENAME%.*})' solution does not contain the cpp file." >&2
        exit 1
    fi

    prepare_cpp_file "${SOL_FILENAME}"

    local filenameReady="${SOL_FILENAME%.*}_ready.${EXTENSION_FILE}"

    if [[ ${TPP_TEST} == "1" ]]; then
        local caseCount=$(get_case_count "${SOL_DIR}")

        if [[ ${caseCount} -eq 0 ]]; then
            echo "Error: '$(basename ${SOL_FILENAME%.*})' solution does not contain test cases."
            exit 1
        fi

        build_cpp_file "${filenameReady}" "${SOL_EXEC}"

        local allPassed=true
        for i in $(seq 1 ${caseCount}); do
            local inFile=$(get_input_file "${SOL_DIR}" ${i})
            local outFile=$(get_output_file "${SOL_DIR}" ${i})
            local expFile=$(get_expected_file "${SOL_DIR}" ${i})

            if isEmpty "${inFile}"; then
                continue
            fi
            if ! fileExists "${expFile}" || isEmpty "${expFile}"; then
                continue
            fi

            local runStatus=0
            run_cpp_file "${filenameReady}" "${SOL_EXEC}" "${inFile}" "${outFile}" false || runStatus=$?

            if [[ ${runStatus} -eq 124 ]]; then
                allPassed=false
            elif [[ $(diff "${expFile}" "${outFile}") != "" ]]; then
                allPassed=false
            fi
        done

        if ${allPassed}; then
            set_test_status_into_config "${SOL_CONFIG}" "Passed"
            echo -e "${BGreen}'$(basename ${filenameReady})' TEST PASSED!${ColorOff}"
        else
            set_test_status_into_config "${SOL_CONFIG}" "Failed"
            echo -e "${BRed}'$(basename ${filenameReady})' TEST FAILED!${ColorOff}"
        fi
    fi

    set_last_update_into_config "${SOL_CONFIG}" "$(date +"%d-%m-%Y") $(date +"%T")"
}

prepare_help() {
    cat <<EOF

Generate and test a new file without the debug references from the .cpp file into
the solution. If the command is run from within the solution directory, the solution
name is an optional argument.

Usage:  tpp prepare [solution-name]

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

prepare_cmd() {
    if [[ ${#} -gt 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    local argument=${1}
    case ${argument} in
        --help | -h)
            prepare_help
            ;;
        *)
            prepare_tpp_solution ${argument}
            ;;
    esac
}
