#!/usr/bin/env bash

## author: KleiberXD

set -e

add_tpp_case() {
    local name=${1}

    resolve_solution ${name}

    # get next case number
    local count=$(get_case_count "${SOL_DIR}")
    local next=$((count + 1))

    local inFile=$(get_input_file "${SOL_DIR}" ${next})
    local expFile=$(get_expected_file "${SOL_DIR}" ${next})

    # create new case files
    touch "${inFile}" "${expFile}"

    echo "Case ${next} created: $(basename ${inFile}), $(basename ${expFile})"

    # last update
    set_last_update_into_config "${SOL_CONFIG}" "$(date +"%d-%m-%Y") $(date +"%T")"

    # open both files in editor
    ${TPP_IDE} "${inFile}" "${expFile}"
}

add_help() {
    cat <<EOF

Add a new test case (input + expected pair) to the solution. If the command is
run from within the solution directory, the solution name is an optional argument.

Usage:  tpp add [solution-name]

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

add_cmd() {
    if [[ ${#} -gt 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    local argument=${1}
    case ${argument} in
        --help | -h)
            add_help
            ;;
        *)
            add_tpp_case ${argument}
            ;;
    esac
}
