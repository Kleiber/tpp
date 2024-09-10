#!/usr/bin/env bash

## author: KleiberXD

set -e

test_tpp_solution() {
    if [[ ${TPP_TEST} == "0" ]]; then
        echo "Set your enviroment variable TPP_TEST to 1"
        exit 0
    fi

    local name=${1}

    local dir=""
    local filename=""
    local configDir=${CONFIG_DIR}
    local configFile="${CONFIG_DIR}/${CONFIG_FILE}"
    local exec=${BUILD}
    local in=${INPUT_FILE}
    local out=${OUTPUT_FILE}
    local exp=${EXPECTED_FILE}

    # check if the solution name is an argument
    if [[ ! ${name} ]]; then
        if ! fileExists ${configFile}; then
            echo "Error: there is not a solution, tpp config file does not exist." >&2
            exit 1
        fi

        filename=$(get_name_from_config ${configFile})
    else
        dir="${TPP_WORKSPACE}/${name}"
        configDir="${dir}/${configDir}"
        configFile="${dir}/${configFile}"
        exec="${dir}/${exec}"
        in="${dir}/${in}"
        out="${dir}/${out}"
        exp="${dir}/${exp}"

        if ! dirExists ${dir}; then
            echo "Error: '${name}' solution does not exist." >&2
            exit 1
        fi

        if ! fileExists ${configFile}; then
            echo "Error: there is not a solution, tpp config file does not exist." >&2
            exit 1
        fi

        filename=$(get_name_from_config ${configFile})
        filename="${dir}/${filename}"
    fi

    if ! fileExists ${filename}; then
        echo "Error: '$(basename ${filename%.*})' solution does not contain the cpp file." >&2
        exit 1
    fi

    if isEmpty ${in}; then
        echo "Error: '$(basename ${filename%.*})' solution does not contain input data."
        exit 1
    fi

    if isEmpty ${exp}; then
        echo "Error: '$(basename ${filename%.*})' solution does not contain expected data."
        exit 1
    fi

    build_cpp_file ${filename} ${exec}

    run_cpp_file ${filename} ${exec} ${in} ${out} false

    test_cpp_file ${filename} ${out} ${exp} ${configFile}

    # get test status
    local testStatus=$(get_test_status_from_config ${configFile})

    BRed='\033[1;31m'
    BGreen='\033[1;32m'
    ColorOff='\033[0m'

    if [[ ${testStatus} == "Passed" ]]; then
        echo -e "${BGreen}'$(basename ${filename})' test PASSED!${ColorOff}"
    else
        echo -e "${BRed}'$(basename ${filename})' test FAILED!${ColorOff}"
    fi

    # last update
    set_last_update_into_config ${configFile} "$(date +"%d-%m-%Y") $(date +"%T")"
}

test_help() {
    cat <<EOF

Compile, run and test the .cpp file into the solution. If the command is run from
within the solution directory, the solution name is an optional argument.

Usage:  tpp test [solution-name]

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

test_cmd() {
    if [[ ${#} -gt 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    local argument=${1}
    case ${argument} in
        --help | -h)
            test_help
            ;;
        *)
            test_tpp_solution ${argument}
            ;;
    esac
}
