#!/usr/bin/env bash

## author: KleiberXD

set -e

function run_tpp_solution() {
    local num=""
    local name=""

    # parse args: number = case, text = solution name
    if [[ ${1} =~ ^[0-9]+$ ]]; then
        num=${1}
        name=${2}
    else
        name=${1}
    fi

    resolve_solution ${name}

    # build
    build_cpp_file "${SOL_FILENAME}" "${SOL_EXEC}"

    local exec="${SOL_EXEC}"
    if [[ "${exec}" != /* ]]; then
        exec="./${exec}"
    fi

    if [[ -z ${num} ]]; then
        # interactive
        "${exec}"
    else
        # run with file input (shows debug)
        local inFile=$(get_input_file "${SOL_DIR}" ${num})
        if ! fileExists "${inFile}"; then
            echo "Error: case ${num} input file does not exist." >&2
            exit 1
        fi
        "${exec}" < "${inFile}"
    fi

    # last update
    set_last_update_into_config "${SOL_CONFIG}" "$(date +"%d-%m-%Y") $(date +"%T")"
}

run_help() {
    cat <<EOF

Compile and run the .cpp file into the solution. Without a case number, runs
interactively. With a case number, runs with that input file.

Usage:  tpp run [case-number] [solution-name]

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

run_cmd() {
    if [[ ${#} -gt 2 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    if [[ ${1} == "--help" ]] || [[ ${1} == "-h" ]]; then
        run_help
        exit 0
    fi

    run_tpp_solution ${@}
}
