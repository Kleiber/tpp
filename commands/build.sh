#!/usr/bin/env bash

## author: KleiberXD

set -e

build_tpp_solution() {
    local name=${1}

    resolve_solution ${name}

    # build cpp file and create executable
    build_cpp_file "${SOL_FILENAME}" "${SOL_EXEC}"

    # last update
    set_last_update_into_config "${SOL_CONFIG}" "$(date +"%d-%m-%Y") $(date +"%T")"

    echo "'$(basename ${SOL_FILENAME%.*})' solution was compiled successfully!"
}

build_help() {
    cat <<EOF

Compile the .cpp file into the solution. If the command is run from within the
solution directory, the solution name is an optional argument.

Usage:  tpp build [solution-name]

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

build_cmd() {
    if [[ ${#} -gt 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    local argument=${1}
    case ${argument} in
        --help | -h)
            build_help
            ;;
        *)
            build_tpp_solution ${argument}
            ;;
    esac
}
