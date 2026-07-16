#!/usr/bin/env bash

## author: KleiberXD

set -e

test_tpp_solution() {
    local name="${1}"

    resolve_solution "${name}"

    if ! fileExists "${SOL_FILENAME}"; then
        echo "Error: '$(basename "${SOL_FILENAME%.*}")' solution does not contain the cpp file." >&2
        exit 1
    fi

    local caseCount=$(get_case_count "${SOL_DIR}")

    if [[ ${caseCount} -eq 0 ]]; then
        echo "Error: '$(basename "${SOL_FILENAME%.*}")' solution does not contain test cases."
        exit 1
    fi

    build_cpp_file "${SOL_FILENAME}" "${SOL_EXEC}"

    local allPassed=true
    local ranAny=false

    for i in $(seq 1 ${caseCount}); do
        local inFile=$(get_input_file "${SOL_DIR}" "${i}")
        local outFile=$(get_output_file "${SOL_DIR}" "${i}")
        local expFile=$(get_expected_file "${SOL_DIR}" "${i}")

        if isEmpty "${inFile}"; then
            echo "Input ${i}: EMPTY"
            continue
        fi

        if ! fileExists "${expFile}"; then
            echo "Input ${i}: EMPTY"
            continue
        fi

        ranAny=true
        local runStatus=0
        local startTime=$(perl -MTime::HiRes=time -e 'printf "%.2f\n", time()')
        run_cpp_file "${SOL_FILENAME}" "${SOL_EXEC}" "${inFile}" "${outFile}" false || runStatus=$?
        local endTime=$(perl -MTime::HiRes=time -e 'printf "%.2f\n", time()')
        local elapsed=$(printf "%.2f" $(echo "${endTime} - ${startTime}" | bc))

        if [[ ${runStatus} -eq 124 ]]; then
            allPassed=false
            echo -e "${BRed}Input ${i}: TLE (${elapsed}s)${ColorOff}"
        elif [[ $(diff "${expFile}" "${outFile}") == "" ]]; then
            echo -e "${BGreen}Input ${i}: PASSED (${elapsed}s)${ColorOff}"
        else
            allPassed=false
            echo -e "${BRed}Input ${i}: FAILED (${elapsed}s)${ColorOff}"
        fi
    done

    if ! ${ranAny}; then
        echo "No test cases with data to run."
        exit 0
    fi

    if ${allPassed}; then
        set_test_status_into_config "${SOL_CONFIG}" "Passed"
        echo ""
        echo -e "${BGreen}'$(basename "${SOL_FILENAME}")' TEST PASSED!${ColorOff}"
    else
        set_test_status_into_config "${SOL_CONFIG}" "Failed"
        echo ""
        echo -e "${BRed}'$(basename "${SOL_FILENAME}")' TEST FAILED!${ColorOff}"
    fi

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

    local argument="${1}"
    case ${argument} in
        --help | -h)
            test_help
            ;;
        *)
            test_tpp_solution "${argument}"
            ;;
    esac
}
