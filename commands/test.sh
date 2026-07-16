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

    if isEmpty "${SOL_IN}"; then
        echo "Error: '$(basename ${SOL_FILENAME%.*})' solution does not contain input data."
        exit 1
    fi

    if isEmpty "${SOL_EXP}"; then
        echo "Error: '$(basename ${SOL_FILENAME%.*})' solution does not contain expected data."
        exit 1
    fi

    build_cpp_file "${SOL_FILENAME}" "${SOL_EXEC}"

    run_cpp_file "${SOL_FILENAME}" "${SOL_EXEC}" "${SOL_IN}" "${SOL_OUT}" false

    test_cpp_file "${SOL_FILENAME}" "${SOL_OUT}" "${SOL_EXP}" "${SOL_CONFIG}"

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
