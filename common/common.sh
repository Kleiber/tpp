#!/bin/bash

## author: KleiberXD

function get_name_from_config() {
    local configFile=${1}
    local name=""

    if isMac; then
        name=$(perl -nle'print $& while m{name\s*=\s*\K[\w\s-._]+}g' ${configFile})
    else
        name=$(cat ${configFile} | grep -oP "name\s*=\s*\K[\w\s._-]+")
    fi

    echo $name
}

function get_create_from_config() {
    local configFile=${1}
    local create=""

    if isMac; then
        create=$(perl -nle'print $& while m{create\s*=\s*\K[\w\s-._:]+}g' ${configFile})
    else
        create=$(cat ${configFile} | grep -oP "create\s*=\s*\K[\w\s._:-]+")
    fi

    echo $create
}

function get_judge_name_from_config() {
    local configFile=${1}
    local judgeName=""

    if isMac; then
        judgeName=$(perl -nle'print $& while m{judge\s*=\s*\K[^\n]+}g' ${configFile})
    else
        judgeName=$(cat ${configFile} | grep -oP "judge\s*=\s*\K.+")
    fi

    echo $judgeName
}

function get_tag_name_from_config() {
    local configFile=${1}
    local tagName=""

    if isMac; then
        tagName=$(perl -nle'print $& while m{tag\s*=\s*\K[^\n]+}g' ${configFile})
    else
        tagName=$(cat ${configFile} | grep -oP "tag\s*=\s*\K.+")
    fi

    echo $tagName
}

function get_last_update_from_config() {
    local configFile=${1}
    local lastUpdate=""

    if isMac; then
        lastUpdate=$(perl -nle'print $& while m{update\s*=\s*\K[\w\s-._:]+}g' ${configFile})
    else
        lastUpdate=$(cat ${configFile} | grep -oP "update\s*=\s*\K[\w\s._:-]+")
    fi

    echo $lastUpdate
}

function get_test_status_from_config() {
    local configFile=${1}
    local testStatus=""

    if isMac; then
        testStatus=$(perl -nle'print $& while m{test\s*=\s*\K[\w\s-._]+}g' ${configFile})
    else
        testStatus=$(cat ${configFile} | grep -oP "test\s*=\s*\K[\w\s._-]+")
    fi

    echo $testStatus
}

function write_config() {
    local configFile=${1}
    local name=${2}
    local create=${3}
    local judge=${4}
    local tag=${5}
    local update=${6}
    local test=${7}

    cat > "${configFile}" <<EOF
[info]
    name = ${name}
    create = ${create}
    judge = ${judge}
    tag = ${tag}
    update = ${update}
    test = ${test}
EOF
}

function set_judge_name_into_config() {
    local configFile=${1}
    local judgeName=${2}

    local name=$(get_name_from_config "${configFile}")
    local create=$(get_create_from_config "${configFile}")
    local tag=$(get_tag_name_from_config "${configFile}")
    local update=$(get_last_update_from_config "${configFile}")
    local test=$(get_test_status_from_config "${configFile}")

    write_config "${configFile}" "${name}" "${create}" "${judgeName}" "${tag}" "${update}" "${test}"
}

function set_tag_name_into_config() {
    local configFile=${1}
    local tagName=${2}

    local name=$(get_name_from_config "${configFile}")
    local create=$(get_create_from_config "${configFile}")
    local judge=$(get_judge_name_from_config "${configFile}")
    local update=$(get_last_update_from_config "${configFile}")
    local test=$(get_test_status_from_config "${configFile}")

    write_config "${configFile}" "${name}" "${create}" "${judge}" "${tagName}" "${update}" "${test}"
}

function set_last_update_into_config() {
    local configFile=${1}
    local lastUpdate=${2}

    local name=$(get_name_from_config "${configFile}")
    local create=$(get_create_from_config "${configFile}")
    local judge=$(get_judge_name_from_config "${configFile}")
    local tag=$(get_tag_name_from_config "${configFile}")
    local test=$(get_test_status_from_config "${configFile}")

    write_config "${configFile}" "${name}" "${create}" "${judge}" "${tag}" "${lastUpdate}" "${test}"
}

function set_test_status_into_config() {
    local configFile=${1}
    local testStatus=${2}

    local name=$(get_name_from_config "${configFile}")
    local create=$(get_create_from_config "${configFile}")
    local judge=$(get_judge_name_from_config "${configFile}")
    local tag=$(get_tag_name_from_config "${configFile}")
    local update=$(get_last_update_from_config "${configFile}")

    write_config "${configFile}" "${name}" "${create}" "${judge}" "${tag}" "${update}" "${testStatus}"
}

resolve_solution() {
    local name=${1}

    if [[ ! ${name} ]]; then
        SOL_DIR="."
        SOL_CONFIG="${CONFIG_DIR}/${CONFIG_FILE}"
        if ! fileExists "${SOL_CONFIG}"; then
            echo "Error: no solution found, tpp config file does not exist." >&2
            exit 1
        fi
        SOL_FILENAME=$(get_name_from_config "${SOL_CONFIG}")
    else
        SOL_DIR="${TPP_WORKSPACE}/${name}"
        SOL_CONFIG="${SOL_DIR}/${CONFIG_DIR}/${CONFIG_FILE}"
        if ! dirExists "${SOL_DIR}"; then
            echo "Error: '${name}' solution does not exist." >&2
            exit 1
        fi
        if ! fileExists "${SOL_CONFIG}"; then
            echo "Error: no solution found, tpp config file does not exist." >&2
            exit 1
        fi
        SOL_FILENAME="${SOL_DIR}/$(get_name_from_config "${SOL_CONFIG}")"
    fi

    SOL_EXEC="${SOL_DIR}/${BUILD}"
}

get_input_file() {
    local dir=${1}
    local num=${2}
    echo "${dir}/${num}.${IN_EXT}"
}

get_output_file() {
    local dir=${1}
    local num=${2}
    echo "${dir}/${num}.${OUT_EXT}"
}

get_expected_file() {
    local dir=${1}
    local num=${2}
    echo "${dir}/${num}.${EXP_EXT}"
}

get_case_count() {
    local dir=${1}
    local count=0
    while fileExists "${dir}/$((count + 1)).${IN_EXT}"; do
        count=$((count + 1))
    done
    echo ${count}
}

build_cpp_file() {
    local cppFile=${1}
    local exec=${2}

    if ! fileExists ${cppFile}; then
        echo "Error: '$(basename ${cppFile})' file does not exist." >&2
        exit 1
    fi

    g++ -std=${TPP_GCC} -o ${exec} ${cppFile}
    if errorExists; then
        echo "Error: '$(basename ${cppFile})' compilation failed." >&2
        exit 1
    fi
}

run_cpp_file() {
    local cppFile=${1}
    local exec=${2}
    local in=${3}
    local out=${4}
    local show=${5}

    if ! fileExists ${exec}; then
        echo "Error: '$(basename ${cppFile%.*})' solution does not contain the executable file." >&2
        exit 1
    fi

    if ! fileExists ${in}; then
        echo "Error: '$(basename ${cppFile%.*})' solution does not contain the input file." >&2
        exit 1
    fi

    if [[ "${exec}" != /* ]]; then
        exec="./${exec}"
    fi

    if isEmpty ${in}; then
        "${exec}"
        if errorExists; then
            echo "Error: '$(basename ${cppFile})' execution failed." >&2
            exit 1
        fi
    else
        if ${show}; then
            "${exec}" < ${in}
        else
            "${exec}" < ${in} 2>/dev/null > ${out}
        fi

        if errorExists; then
            echo "Error: '$(basename ${cppFile})' execution with input data failed." >&2
            exit 1
        fi
    fi
}

test_cpp_file() {
    local cppFile=${1}
    local out=${2}
    local exp=${3}
    local configFile=${4}

    local status="Pending"

    local red="\x1b[31m"
    local green="\x1b[32m"
    local off="\x1b[0m"

    local Red='\033[1;31m'
    local Green='\033[1;32m'
    local Off='\033[0m'

    local headerExp="====== Expected ======"
    local headerOut="======= Output ======="

    if ! fileExists ${out}; then
        echo "Error: '$(basename ${cppFile%.*})' solution does not contain the output file." >&2
        exit 1
    fi

    if ! fileExists ${exp}; then
        echo "Error: '$(basename ${cppFile%.*})' solution does not contain the expected file." >&2
        exit 1
    fi

    if [[ $(diff ${exp} ${out}) ==  "" ]] ; then
        status="Passed"
        echo -e "${Green}'$(basename ${cppFile})' TEST PASSED!${Off}"
    else
        status="Failed"

        diff -c ${exp} ${out} | \
            sed "/^\*\*/s/.*/${headerExp}/" | \
            sed "/^\-\-/s/.*/${headerOut}/" | \
            sed -e "s/^!/${red}x${off}/" | \
            tail -n +4 || true

        echo ""
        echo -e "${Red}'$(basename ${cppFile})' TEST FAILED!${Off}"
    fi

    set_test_status_into_config ${configFile} ${status}
}

prepare_cpp_file() {
    local cppFile=${1}

    local cppTmpFile="$(dirname ${cppFile})/.$(basename ${cppFile})"
    local cppReadyFile="${cppFile%.*}_ready.${EXTENSION_FILE}"

    # TODO: investigate how to put the below two sed command in one
    # line, for some reason the next command is not working in Mac OS
    # $ sed '/debug.h\|debug(/d' $1

    # remove 'include' reference
    sed '/debug.h/d' ${cppFile} > ${cppReadyFile}
    if errorExists; then
        echo "Error: '$(basename ${cppFile%.*})' solution prepare file failed." >&2
        exit 1
    fi

    # remove 'debugm(<var>)' use
    sed '/debugm(/d' ${cppReadyFile} > ${cppTmpFile}
    if errorExists; then
        echo "Error: '$(basename ${cppFile%.*})' solution prepare file failed." >&2
        exit 1
    fi

    # remove 'debug(<var>)' use
    sed '/debug(/d' ${cppTmpFile} > ${cppReadyFile}
    if errorExists; then
        echo "Error: '$(basename ${cppFile%.*})' solution prepare file failed." >&2
        exit 1
    fi

    rm ${cppTmpFile}

    echo "'$(basename ${cppReadyFile})' was generated successfully!"
}
