#!/usr/bin/env bash

## author: KleiberXD

set -e

check_submit_setup() {
    if [[ "${TPP_GITHUB}" == "tpp_github" ]]; then
        echo "Error: 'TPP_GITHUB' is unset, please set a value." >&2
        exit 1
    fi

    if [[ "${TPP_REPO}" == "tpp_repo" ]]; then
        echo "Error: 'TPP_REPO' is unset, please set a value." >&2
        exit 1
    fi

    if [[ "${TPP_BRANCH}" == "tpp_branch" ]]; then
        echo "Error: 'TPP_BRANCH' is unset, please set a value." >&2
        exit 1
    fi
}

submit_tpp_solution() {
    local name="${1}"

    resolve_solution "${name}"

    local repoDir="${TPP_REPO}"

    if ! dirExists "${repoDir}"; then
        echo "Cloning into '${repoDir}'..."
        git clone --quiet "${TPP_GITHUB}" "${repoDir}"
    fi

    local tagName=$(get_tag_name_from_config "${SOL_CONFIG}")
    local judgeName=$(get_judge_name_from_config "${SOL_CONFIG}")
    if [[ "${judgeName}" == "empty" ]]; then
        echo "Error: judge name unset. please set a value." >&2
        exit 1
    fi

    local judgeDir=""
    if [[ "${tagName}" == "empty" ]]; then
        judgeDir="${judgeName}"
    else
        judgeDir="${judgeName}/${tagName}"
    fi

    local targetDir="${repoDir}/${judgeDir}"
    local testStatus=$(get_test_status_from_config "${SOL_CONFIG}")

    if [[ "${TPP_TEST}" == "1" && "${testStatus}" != "Passed" ]]; then
        echo "Error: The tests did not pass, first test your solution!" >&2
        exit 1
    fi

    local filenameReady="${SOL_FILENAME%.*}_ready.${EXTENSION_FILE}"

    if ! fileExists "${filenameReady}"; then
        echo "Error: prepare file does not exists. Prepare your solution!" >&2
        exit 1
    fi

    # Sync with remote branch before pushing
    pushd "${repoDir}" > /dev/null
    git checkout --quiet "${TPP_BRANCH}"
    git pull --quiet origin "${TPP_BRANCH}"
    popd > /dev/null

    mkdir -p "${targetDir}"
    cp "${filenameReady}" "${targetDir}"

    echo "Insert a commit message and press enter:"
    read commitMessage

    # Stage only the target file (avoid committing unrelated files)
    echo "Pushing '$(basename "${filenameReady}")' to '${judgeDir}' directory..."
    pushd "${repoDir}" > /dev/null
    git add "${judgeDir}/$(basename "${filenameReady}")"
    git commit --quiet --message "${commitMessage}"
    git push --quiet origin "${TPP_BRANCH}"
    popd > /dev/null
    echo "'$(basename "${SOL_FILENAME%.*}")' solution was upload to the github repo successfully!"
}

submit_help() {
    cat <<EOF

Submit the solution to the github repository, the path where it will be placed is the
concatenation of the judge and tag name. If the command is run from within the solution
directory, the solution name is an optional argument.

Usage:  tpp submit [solution-name]

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

submit_cmd() {
    if [[ ${#} -gt 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    local argument="${1}"
    case ${argument} in
        --help | -h)
            submit_help
            ;;
        *)
            check_submit_setup
            submit_tpp_solution "${argument}"
            ;;
    esac
}
