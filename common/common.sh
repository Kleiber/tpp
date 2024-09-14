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

function get_judge_name_from_config() {
    local configFile=${1}
    local judgeName=""

    if isMac; then
        judgeName=$(perl -nle'print $& while m{judge\s*=\s*\K[\w\s-._]+}g' ${configFile})
    else
        judgeName=$(cat ${configFile} | grep -oP "judge\s*=\s*\K[\w\s._-]+")
    fi

    echo $judgeName
}

function get_tag_name_from_config() {
    local configFile=${1}
    local tagName=""

    if isMac; then
        tagName=$(perl -nle'print $& while m{tag\s*=\s*\K[\w\s-._]+}g' ${configFile})
    else
        tagName=$(cat ${configFile} | grep -oP "tag\s*=\s*\K[\w\s._-]+")
    fi

    echo $tagName
}

function get_last_update_from_config() {
    local configFile=${1}
    local lastUpdate=""

    if isMac; then
        lastUpdate=$(perl -nle'print $& while m{update\s*=\s*\K[\w\s-._:]+}g' ${configFile})
    else
        lastUpdate=$(cat ${configFile} | grep -oP "update\s*=\s*\K[\w\s._-]+")
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

function set_judge_name_into_config() {
    local configFile=${1}
    local judgeName=${2}
    local currentJudgeName=$(get_judge_name_from_config ${configFile})

    sed -i -e "s/judge = ${currentJudgeName}/judge = ${judgeName}/g" ${configFile}
    if errorExists; then
        echo "Error: set judge name failed." >&2
        exit 1
    fi
}

function set_tag_name_into_config() {
    local configFile=${1}
    local tagName=${2}
    local currentTagName=$(get_tag_name_from_config ${configFile})

    sed -i -e "s/tag = ${currentTagName}/tag = ${tagName}/g" ${configFile}
    if errorExists; then
        echo "Error: set tag name failed." >&2
        exit 1
    fi
}

function set_last_update_into_config() {
    local configFile=${1}
    local lastUpdate=${2}
    local currentLastUpdate=$(get_last_update_from_config ${configFile})

    sed -i -e "s/update = ${currentLastUpdate}/update = ${lastUpdate}/g" ${configFile}
    if errorExists; then
        echo "Error: set last update failed." >&2
        exit 1
    fi
}

function set_test_status_into_config() {
    local configFile=${1}
    local testStatus=${2}
    local currentTestStatus=$(get_test_status_from_config ${configFile})

    sed -i -e "s/test = ${currentTestStatus}/test = ${testStatus}/g" ${configFile}
    if errorExists; then
        echo "Error: set test status failed." >&2
        exit 1
    fi
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

    if isEmpty ${in}; then
        ${exec}
        if errorExists; then
            echo "Error: '$(basename ${cppFile})' execution failed." >&2
            exit 1
        fi
    else
        if ${show}; then
            ${exec} < ${in}
        else
            ${exec} < ${in} 2>/dev/null > ${out}
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
