#!/usr/bin/env bash

## author: KleiberXD

set -e

function run_tpp_solution() {
    local name=${1}

    local dir=""
    local filename=""
    local configDir=${CONFIG_DIR}
    local configFile="${CONFIG_DIR}/${CONFIG_FILE}"
    local exec=${BUILD}
    local in=${INPUT_FILE}
    local out=${OUTPUT_FILE}

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

    # build cpp file and create executable
    build_cpp_file ${filename} ${exec}

    # run cpp executable
    run_cpp_file ${filename} ${exec} ${in} ${out} true

    # last update
    set_last_update_into_config ${configFile} "$(date +"%d-%m-%Y") $(date +"%T")"
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
