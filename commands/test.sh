#!/usr/bin/env bash

## author: KleiberXD

set -e

test_tpp_solution() {
    if [[ ${TPP_TEST} == "0" ]]; then
        echo "Set your enviroment variable TPP_TEST to 1"
        exit 0
    fi

    local name=${1}

    resolve_solution ${name}

    if ! fileExists "${SOL_FILENAME}"; then
        echo "Error: '$(basename ${SOL_FILENAME%.*})' solution does not contain the cpp file." >&2
        exit 1
    fi

    local caseCount=$(get_case_count "${SOL_DIR}")

    if [[ ${caseCount} -eq 0 ]]; then
        echo "Error: '$(basename ${SOL_FILENAME%.*})' solution does not contain test cases."
        exit 1
    fi

    build_cpp_file "${SOL_FILENAME}" "${SOL_EXEC}"

    local allPassed=true
    local ranAny=false

    for i in $(seq 1 ${caseCount}); do
        local inFile=$(get_input_file "${SOL_DIR}" ${i})
        local outFile=$(get_output_file "${SOL_DIR}" ${i})
        local expFile=$(get_expected_file "${SOL_DIR}" ${i})

        if isEmpty "${inFile}"; then
            echo "Case ${i}: SKIPPED (empty input)"
            continue
        fi

        if ! fileExists "${expFile}" || isEmpty "${expFile}"; then
            echo "Case ${i}: SKIPPED (no expected output)"
            continue
        fi

        ranAny=true
        run_cpp_file "${SOL_FILENAME}" "${SOL_EXEC}" "${inFile}" "${outFile}" false

        if [[ $(diff "${expFile}" "${outFile}") == "" ]]; then
            echo -e "${BGreen}Case ${i}: PASSED${ColorOff}"
        else
            allPassed=false
            echo -e "${BRed}Case ${i}: FAILED${ColorOff}"
            diff "${expFile}" "${outFile}" | head -10 || true
            echo ""
        fi
    done

    if ! ${ranAny}; then
        echo "No test cases with data to run."
        exit 0
    fi

    # update test status
    if ${allPassed}; then
        set_test_status_into_config "${SOL_CONFIG}" "Passed"
    else
        set_test_status_into_config "${SOL_CONFIG}" "Failed"
    fi

    # last update
    set_last_update_into_config "${SOL_CONFIG}" "$(date +"%d-%m-%Y") $(date +"%T")"
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
