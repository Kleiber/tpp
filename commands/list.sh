#!/usr/bin/env bash

## author: KleiberXD

set -e

list_tpp_solutions() {
    if [[ $(ls ${TPP_WORKSPACE}) == "" ]] ; then
        echo "Nothing to list! "
        exit 0
    fi

    local listSolutions=$(ls -d ${TPP_WORKSPACE}/*)
    # print colum headers
    printf "%-25s  %-13s  %-13s  %-8s  %s\n" "SOLUTION NAME" "JUDGE" "TEST STATUS" "READY" "LAST UPDATE"

    # list all solution directories
    for solutionDir in ${listSolutions}; do
        local solutionName=${solutionDir#"${TPP_WORKSPACE}/"}
        local solutionConfigFile="${solutionDir}/${SOLUTION_CONFIG_DIR}/${SOLUTION_CONFIG_FILE}"
        local solutionFilenameReady="${solutionDir}/${solutionName}_ready.${SOLUTION_EXTENSION_FILE}"

        local judgeName=$(get_judge_name_from_config ${solutionConfigFile})
        local testStatus=$(get_test_status_from_config ${solutionConfigFile})
        local lastUpdate=$(get_last_update_from_config ${solutionConfigFile})
        local isReady="No"

        if [[ ${judgeName} == "empty" ]]; then
            judgeName=""
        fi

        if fileExists ${solutionFilenameReady} && [[ ${testStatus} == "Passed" ]]; then
            isReady="Yes"
        fi

        printf "%-25s  %-13s  %-13s  %-8s  %s\n" "${solutionName}" "${judgeName}" "${testStatus}" "${isReady}" "${lastUpdate}"
    done

}

list_help() {
    cat <<EOF

List all solutions in the workspace.

Usage:  tpp list

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

    local argument=${1}
    case ${argument} in
        --help | -h)
            list_help
            ;;
        *)
            list_tpp_solutions ${argument}
            ;;
    esac
}
