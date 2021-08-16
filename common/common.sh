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
        echo "Error: '${cppFile}' file does not exist." >&2
        exit 1
    fi

    g++ -std=c++11 -o ${execFile} ${cppFile}
    if errorExists; then
        echo "Error: '${cppFile}' compilation failed." >&2
        exit 1
    fi
}

run_cpp_file() {
    local solutionFilename=${1}
    local execFile=${2}
    local inputFile=${3}
    local outputFile=${4}
    local showOutput=${5}

    if ! fileExists ${execFile}; then
        echo "Error: solution '${solutionFilename}' does not contain the executable." >&2
        exit 1
    fi

    if ! fileExists ${inputFile}; then
        echo "Error: solution '${solutionFilename}' does not contain the in.tpp file." >&2
        exit 1
    fi

    if ${showOutput}; then
        if isEmpty ${solutionInput}; then
            ${execFile}
            if errorExists; then
                echo "Error: '${cppFile}' execution failed." >&2
                exit 1
            fi
        else
            ${execFile} < ${inputFile}
            if errorExists; then
                echo "Error: '${cppFile}' execution with input failed." >&2
                exit 1
            fi
        fi
    else
        if isEmpty ${solutionInput}; then
            ${execFile} 2>/dev/null > ${outputFile}
            if errorExists; then
                echo "Error: '${cppFile}' execution failed." >&2
                exit 1
            fi
        else
            ${execFile} < ${inputFile} 2>/dev/null > ${outputFile}
            if errorExists; then
                echo "Error: '${cppFile}' execution with input failed." >&2
                exit 1
            fi
        fi
    fi
}

test_cpp_file() {
    local solutionFilename=${1}
    local outputFile=${2}
    local expectedFile=${3}
    local configFile=${4}

    if ! fileExists ${outputFile}; then
        echo "Error: solution '${solutionFilename}' does not contain the out.tpp file." >&2
        exit 1
    fi

    if ! fileExists ${expectedFile}; then
        echo "Error: solution '${solutionFilename}' does not contain the expected.tpp file." >&2
        exit 1
    fi

    if isMac; then
        diff ${expectedFile} ${outputFile}
    else
        diff ${expectedFile} ${outputFile} --color
    fi

    if errorExists; then
        echo diff ${expectedFile} ${outputFile} >&2
        echo "'${solutionFilename}' test FAILED!"
        # update test status
        set_test_status_into_config ${configFile} "Failed"
        exit 1
    fi

    echo "'${solutionFilename}' test PASSED!"

    # update test status
    set_test_status_into_config ${configFile} "Passed"
}

prepare_cpp_file() {
    local solutionFilename=${1}
    local outputFile=${2}
    local expectedFile=${3}
    local configFile=${4}

    local cppTmpFile="$(dirname ${solutionFilename})/.$(basename ${solutionFilename})"
    local cppReadyFile="${solutionFilename%.*}_ready.${SOLUTION_EXTENSION_FILE}"

    # TODO: investigate how to put the below two sed command in one
    # line, for some reason the next command is not working in Mac OS
    # $ sed '/debug.h\|debug(/d' $1

    # remove 'include' reference
    sed '/debug.h/d' ${solutionFilename} > ${cppReadyFile}
    if errorExists; then
        echo "Error: prepare '${solutionFilename}' file failed" >&2
        exit 1
    fi

    # remove 'debugm(<var>)' use
    sed '/debugm(/d' ${cppReadyFile} > ${cppTmpFile}
    if errorExists; then
        echo "Error: prepare '${solutionFilename}' file failed" >&2
        exit 1
    fi

    # remove 'debug(<var>)' use
    sed '/debug(/d' ${cppTmpFile} > ${cppReadyFile}
    if errorExists; then
        echo "Error: prepare '${solutionFilename}' file failed" >&2
        exit 1
    fi

    rm ${cppTmpFile}

    echo "'${cppReadyFile}' was generated successfully!"

    test_cpp_file ${cppReadyFile} ${outputFile} ${expectedFile} ${configFile}
}
