#!/usr/bin/env bash

## author: KleiberXD

set -e

list_tpp_solutions() {
    local listSolutions=$(ls -d ${TPP_WORKSPACE}/*)

    # print colum headers
    printf "%-30s  %-15s  %-15s  %-20s  %-5s\n" "SOLUTION NAME" "JUDGE" "TEST STATUS" "LAST UPDATE" "READY"

    # list all solution directories
    for solutionDir in ${listSolutions}; do
        local solutionName=${solutionDir#"${TPP_WORKSPACE}/"}
        local solutionConfigFile="${solutionDir}/${SOLUTION_CONFIG_DIR}/${SOLUTION_CONFIG_FILE}"
        local solutionFilenameReady="${solutionDir}/${solutionName}_ready.${SOLUTION_EXTENSION_FILE}"

        local judgeName=$(get_judge_name_from_config ${solutionConfigFile})
        local testStatus=$(get_test_status_from_config ${solutionConfigFile})
        local lastUpdate=$(get_last_update_from_config ${solutionConfigFile})
        local isReady="No"

        if fileExists ${solutionFilenameReady} && [[ ${testStatus} == "passed" ]]; then
            isReady="Yes"
        fi

        printf "%-30s  %-15s  %-15s  %-20s  %-5s\n" "${solutionName}" "${judgeName}" "${testStatus}" "${lastUpdate}" "${isReady}"
    done

}

list_help() {
    cat <<EOF

List all solutions in the workspace.

Usage:  tpp test [solution-name]

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
