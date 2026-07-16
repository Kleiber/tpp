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

    # prepare cpp solution to submit
    prepare_cpp_file "${SOL_FILENAME}"

    # prepare filename
    local filenameReady="${SOL_FILENAME%.*}_ready.${EXTENSION_FILE}"

    # test prepare cpp solution and update status
    if [[ ${TPP_TEST} == "1" ]]; then
        if isEmpty "${SOL_IN}"; then
            echo "Error: '$(basename ${SOL_FILENAME%.*})' solution does not contain input data."
            exit 1
        fi

        if isEmpty "${SOL_EXP}"; then
            echo "Error: '$(basename ${SOL_FILENAME%.*})' solution does not contain expected data."
            exit 1
        fi

        build_cpp_file "${filenameReady}" "${SOL_EXEC}"

        run_cpp_file "${filenameReady}" "${SOL_EXEC}" "${SOL_IN}" "${SOL_OUT}" false

        test_cpp_file "${filenameReady}" "${SOL_OUT}" "${SOL_EXP}" "${SOL_CONFIG}"
    fi

    # last update
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
