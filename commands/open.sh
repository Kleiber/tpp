#!/usr/bin/env bash

## author: KleiberXD

set -e

open_tpp_solution() {
    local name="${1}"

    resolve_solution "${name}"

    if ! fileExists "${SOL_FILENAME}"; then
        echo "Error: '$(basename "${SOL_FILENAME%.*}")' solution does not contain the cpp file." >&2
        exit 1
    fi

    set_last_update_into_config "${SOL_CONFIG}" "$(date +"%d-%m-%Y") $(date +"%T")"

    local -a ide_cmd=("${TPP_IDE}")
    if [[ "${TPP_IDE}" == "vi" || "${TPP_IDE}" == "vim" ]]; then
        ide_cmd=("${TPP_IDE}" -u "${TPP_VIMRC}")
    fi

    if [[ "${TPP_VIEWS}" == "1" ]]; then
        local inFile=$(get_input_file "${SOL_DIR}" 1)
        local expFile=$(get_expected_file "${SOL_DIR}" 1)
        "${ide_cmd[@]}" -O "${SOL_FILENAME}" "${expFile}" -c "winc l" -c "sp ${inFile}" -c "vertical res 60" -c "winc h"
    else
        "${ide_cmd[@]}" "${SOL_FILENAME}"
    fi
}

open_help() {
    cat <<EOF

Open .cpp file into the solution name. If the command is run from within the
solution directory, the solution name is an optional argument.

Usage:  tpp open [solution-name]

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

open_cmd() {
    if [[ ${#} -gt 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    local argument="${1}"
    case ${argument} in
        --help | -h)
            open_help
            ;;
        *)
            open_tpp_solution "${argument}"
            ;;
    esac
}
