#!/usr/bin/env bash

## author: KleiberXD

set -e

function run_tpp_solution() {
    local name=${1}

    resolve_solution ${name}

    local inFile=$(get_input_file "${SOL_DIR}" 1)
    local outFile=$(get_output_file "${SOL_DIR}" 1)

    # build cpp file and create executable
    build_cpp_file "${SOL_FILENAME}" "${SOL_EXEC}"

    # run cpp executable
    run_cpp_file "${SOL_FILENAME}" "${SOL_EXEC}" "${inFile}" "${outFile}" true

    # last update
    set_last_update_into_config "${SOL_CONFIG}" "$(date +"%d-%m-%Y") $(date +"%T")"
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
