#!/bin/bash

## author: KleiberXD

function get_name_from_config() {
    local configFile=${1}
    local name=""

    if isMac; then
        name=$(perl -nle'print $& while m{name\s*=\s*\K[\w\s-._]+}g' ${configFile})
    else
        name=$(cat ${configFile} | grep -oP "name\s*=\s*\K[\w\s-._]+")
    fi

    echo $name
}

function get_judge_name_from_config() {
    local configFile=${1}
    local judgeName=""

    if isMac; then
        judgeName=$(perl -nle'print $& while m{judge\s*=\s*\K[\w\s-._]+}g' ${configFile})
    else
        judgeName=$(cat ${configFile} | grep -oP "judge\s*=\s*\K[\w\s-._]+")
    fi

    echo $judgeName
}

function get_tag_name_from_config() {
    local configFile=${1}
    local tagName=""

    if isMac; then
        tagName=$(perl -nle'print $& while m{tag\s*=\s*\K[\w\s-._]+}g' ${configFile})
    else
        tagName=$(cat ${configFile} | grep -oP "tag\s*=\s*\K[\w\s-._]+")
    fi

    echo $tagName
}

function get_last_update_from_config() {
    local configFile=${1}
    local lastUpdate=""

    if isMac; then
        lastUpdate=$(perl -nle'print $& while m{update\s*=\s*\K[\w\s-._:]+}g' ${configFile})
    else
        lastUpdate=$(cat ${configFile} | grep -oP "update\s*=\s*\K[\w\s-._:]+")
    fi

    echo $lastUpdate
}

function get_test_status_from_config() {
    local configFile=${1}
    local testStatus=""

    if isMac; then
        testStatus=$(perl -nle'print $& while m{test\s*=\s*\K[\w\s-._]+}g' ${configFile})
    else
        testStatus=$(cat ${configFile} | grep -oP "test\s*=\s*\K[\w\s-._]+")
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
    local execFile=${2}

    if ! fileExists ${cppFile}; then
        echo "Error: '$(basename ${cppFile})' file does not exist." >&2
        exit 1
    fi

    g++ -std=c++11 -o ${execFile} ${cppFile}
    if errorExists; then
        echo "Error: '$(basename ${cppFile})' compilation failed." >&2
        exit 1
    fi
}

run_cpp_file() {
    local cppFile=${1}
    local execFile=${2}
    local inputFile=${3}
    local outputFile=${4}
    local showOutput=${5}

    if ! fileExists ${execFile}; then
        echo "Error: '$(basename ${cppFile%.*})' solution does not contain the executable file." >&2
        exit 1
    fi

    if ! fileExists ${inputFile}; then
        echo "Error: '$(basename ${cppFile%.*})' solution does not contain the input file." >&2
        exit 1
    fi

    if ${showOutput}; then
        if isEmpty ${solutionInput}; then
            ${execFile}
            if errorExists; then
                echo "Error: '$(basename ${cppFile})' execution failed." >&2
                exit 1
            fi
        else
            ${execFile} < ${inputFile}
            if errorExists; then
                echo "Error: '$(basename ${cppFile})' execution with input data failed." >&2
                exit 1
            fi
        fi
    else
        if isEmpty ${solutionInput}; then
            ${execFile} 2>/dev/null > ${outputFile}
            if errorExists; then
                echo "Error: '$(basename ${cppFile})' execution failed." >&2
                exit 1
            fi
        else
            ${execFile} < ${inputFile} 2>/dev/null > ${outputFile}
            if errorExists; then
                echo "Error: '$(basename ${cppFile})' execution with input data failed." >&2
                exit 1
            fi
        fi
    fi
}

test_cpp_file() {
    local cppFile=${1}
    local outputFile=${2}
    local expectedFile=${3}
    local configFile=${4}

    if ! fileExists ${outputFile}; then
        echo "Error: '$(basename ${cppFile%.*})' solution does not contain the output file." >&2
        exit 1
    fi

    if ! fileExists ${expectedFile}; then
        echo "Error: '$(basename ${cppFile%.*})' solution does not contain the expected file." >&2
        exit 1
    fi

    local difference=""
    if isMac; then
        difference=$(diff ${expectedFile} ${outputFile} || true)
    else
        difference=$(diff ${expectedFile} ${outputFile} --color || true)
    fi

    if [[ ${difference} != "" ]]; then
        echo ${difference}
        set_test_status_into_config ${configFile} "Failed"
    else
        set_test_status_into_config ${configFile} "Passed"
    fi
}

prepare_cpp_file() {
    local cppFile=${1}
    local outputFile=${2}
    local expectedFile=${3}

    local cppTmpFile="$(dirname ${cppFile})/.$(basename ${cppFile})"
    local cppReadyFile="${cppFile%.*}_ready.${SOLUTION_EXTENSION_FILE}"

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
