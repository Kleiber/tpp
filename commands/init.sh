#!/usr/bin/env bash

## author: KleiberXD

set -e

function init_tpp_solution() {
    local name="${1}"
    local dir="${TPP_WORKSPACE}/${name}"
    local configDir="${dir}/${CONFIG_DIR}"

    if ! isValidName "${name}"; then
        echo "Error: invalid solution name '${name}'." >&2
        exit 1
    fi

    if dirExists "${dir}"; then
        echo "Error: '${name}' solution already exists." >&2
        exit 1
    fi

    mkdir -p "${dir}" "${configDir}"
    touch "$(get_input_file "${dir}" 1)" "$(get_expected_file "${dir}" 1)"

    local configFile="${configDir}/${CONFIG_FILE}"
    local filename="${name}.${EXTENSION_FILE}"
    config_template "${filename}" "${configFile}"

    # debug.h path must be absolute for the #include directive
    local debugRefPath="${TPP_DIR}"

    if isWindows; then
        local partition="${debugRefPath:1:1}"
        debugRefPath="${partition^}:${debugRefPath:2}"
    fi

    if isMac; then
        mac_os_template "${dir}" "${filename}" "${debugRefPath}"
    else
        linux_os_template "${dir}" "${filename}" "${debugRefPath}"
    fi

    if [[ "${TPP_FILL}" == "1" ]]; then
        echo "Loading samples..."
        python3 -W ignore "${TPP_DIR}/scraper/scraper.py" "${name}" "${dir}"
    fi

    echo "'${name}' solution was initialized successfully!"
}

init_help() {
    cat <<EOF

Init a new solution with the specified name in the workspace.

Usage:  tpp init <solution-name>

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

init_cmd() {
    if [[ ${#} -gt 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    local argument="${1}"
    case ${argument} in
        --help | -h)
            init_help
            ;;
        *)
            init_tpp_solution "${argument}"
            ;;
    esac
}
