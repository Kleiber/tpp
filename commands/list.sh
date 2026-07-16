#!/usr/bin/env bash

## author: KleiberXD

set -e

list_tpp_solutions() {
    local found=false

    printf "%-25s  %-13s  %-13s %-13s  %-8s  %s\n" \
        "SOLUTION NAME" "JUDGE" "TAG" "TEST STATUS" "READY" "LAST UPDATE"

    for dir in "${TPP_WORKSPACE}"/*/; do
        # Skip if glob didn't expand (empty workspace)
        [[ -d "${dir}" ]] || continue

        local configFile="${dir}${CONFIG_DIR}/${CONFIG_FILE}"

        # Skip non-solution directories (no tpp config)
        [[ -f "${configFile}" ]] || continue

        found=true

        local name="${dir%/}"
        name="${name##*/}"
        local filenameReady="${dir}${name}_ready.${EXTENSION_FILE}"

        local judgeName=$(get_judge_name_from_config "${configFile}")
        local tagName=$(get_tag_name_from_config "${configFile}")
        local testStatus=$(get_test_status_from_config "${configFile}")
        local lastUpdate=$(get_last_update_from_config "${configFile}")
        local isReady="No"

        if [[ "${judgeName}" == "empty" ]]; then
            judgeName=""
        fi

        if [[ "${tagName}" == "empty" ]]; then
            tagName=""
        fi

        if [[ -f "${filenameReady}" ]] && [[ "${testStatus}" == "Passed" ]]; then
            isReady="Yes"
        fi

        printf "%-25s  %-13s  %-13s %-13s  %-8s  %s\n" \
            "${name}" "${judgeName}" "${tagName}" "${testStatus}" "${isReady}" "${lastUpdate}"
    done

    if ! ${found}; then
        echo "Nothing to list!"
    fi
}

list_help() {
    cat <<EOF

List all solutions in the workspace.

Usage:  tpp ls

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

list_cmd() {
    if [[ ${#} -gt 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    local argument="${1}"
    case ${argument} in
        --help | -h)
            list_help
            ;;
        *)
            list_tpp_solutions "${argument}"
            ;;
    esac
}
