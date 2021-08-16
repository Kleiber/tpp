#!/usr/bin/env bash

## author: KleiberXD

set -e

check_submit_setup() {
    if [[ ${TPP_REPO} == "tpp_repo" ]]; then
        echo "Error: 'TPP_REPO' is unset, please set a valuee." >&2
        exit 1
    fi

    if [[ ${TPP_BRANCH} == "tpp_branch" ]]; then
        echo "Error: 'TPP_BRANCH' is unset, please set a value." >&2
        exit 1
    fi
}

submit_tpp_solution() {
    local solutionName=${1}
    local solutionDir="${TPP_WORKSPACE}/${solutionName}"
    local solutionConfigDir="${solutionDir}/${SOLUTION_CONFIG_DIR}"
    local solutionConfigFile="${solutionDir}/${SOLUTION_CONFIG_DIR}/${SOLUTION_CONFIG_FILE}"

    if isValidName ${solutionName}; then
        echo "Error: invalid solution name '${solutionName}'." >&2
        exit 1
    fi

    if ! dirExists ${solutionDir}; then
        echo "Error: '${solutionName}' solution does not exist." >&2
        exit 1
    fi

    # clone tpp github repo if it does not exist yet
    repoGithub=$(basename ${TPP_REPO})
    repoDir="${HOME}/${repoGithub%.*}"

    if ! dirExists ${repoDir}; then
        echo "Cloning into '${repoDir}'..."
        git clone --quiet ${TPP_REPO} ${repoDir}
    fi

    # checkout to the tpp branch and update it
    cd ${repoDir}
    git checkout --quiet ${TPP_BRANCH}
    git pull --quiet origin ${TPP_BRANCH}

    # retrieve test status
    local testStatus=$(get_test_status_from_config ${solutionConfigFile})

    if [[ ${testStatus} != "passed" ]]; then
        echo "Error: The tests did not pass, first test your solution!" >&2
        exit 1
    fi

    # retrive filename
    local solutionFilename=$(get_name_from_config ${solutionConfigFile})
    local solutionFilenameReady="${solutionFilename%.*}_ready.${SOLUTION_EXTENSION_FILE}"

    if ! fileExists "${solutionDir}/${solutionFilenameReady}"; then
        echo "Error: '${solutionFilenameReady}' file does not exist. Prepare your solution!" >&2
        exit 1
    fi

    # retrieve judge
    local judgeName=$(get_judge_name_from_config ${solutionConfigFile})
    local judgeDir="${repoDir}/${judgeName}" 

    # copy solution to repo
    mkdir -p ${judgeDir}
    cp "${solutionDir}/${solutionFilenameReady}" ${judgeDir}

    # request commit message
    echo "Insert a commit message and press enter:"
    read commitMessage

    # push changes to github repo
    echo "Pushing '${solutionFilenameReady}' to '${judgeDir}' directory..."
    git add .
    git commit --quiet --message "${commitMessage}"
    git push --quiet origin ${TPP_BRANCH}
    echo "Solution '${solutionFilenameReady}' was upload to the github repo successfully!"

    # clean solution from worspace
    rm -rf ${solutionDir}
}

submit_help() {
    cat <<EOF

Submit solution to github repository. If the command is run from
within the solution directory, the solution name is an optional argument.

Usage:  tpp test [solution-name]

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

    local argument=${1}
    case ${argument} in
        --help | -h)
            submit_help
            ;;
        *)
            check_submit_setup
            submit_tpp_solution ${argument}
            ;;
    esac
}