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

run_with_timeout() {
    local limit=${TPP_TL}
    local exec=${1}
    local in=${2}
    local out=${3}
    local show=${4}

    local status=0
    if ${show}; then
        (
            set +e
            "${exec}" < "${in}" &
            local pid=$!
            (sleep ${limit}; kill ${pid} 2>/dev/null) &
            local watchdog=$!
            wait ${pid} 2>/dev/null
            status=$?
            kill ${watchdog} 2>/dev/null
            wait ${watchdog} 2>/dev/null
            if [[ ${status} -eq 137 || ${status} -eq 143 ]]; then
                exit 124
            fi
            exit ${status}
        )
        status=$?
    else
        (
            set +e
            "${exec}" < "${in}" 2>/dev/null > "${out}" &
            local pid=$!
            (sleep ${limit}; kill ${pid} 2>/dev/null) &
            local watchdog=$!
            wait ${pid} 2>/dev/null
            status=$?
            kill ${watchdog} 2>/dev/null
            wait ${watchdog} 2>/dev/null
            if [[ ${status} -eq 137 || ${status} -eq 143 ]]; then
                exit 124
            fi
            exit ${status}
        )
        status=$?
    fi
    return ${status}
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
        local status=0
        run_with_timeout "${exec}" "${in}" "${out}" ${show} || status=$?

        if [[ ${status} -eq 124 ]]; then
            return 124
        fi

        if [[ ${status} -ne 0 ]]; then
            echo "Error: '$(basename ${cppFile})' execution with input data failed." >&2
            exit 1
        fi
    fi
}

prepare_cpp_file() {
    local cppFile=${1}

    local cppReadyFile="${cppFile%.*}_ready.${EXTENSION_FILE}"

    sed '/debug\.h/d; /debugm(/d; /debug(/d; /debugt(/d' ${cppFile} > ${cppReadyFile}
    if errorExists; then
        echo "Error: '$(basename ${cppFile%.*})' solution prepare file failed." >&2
        exit 1
    fi

    echo "'$(basename ${cppReadyFile})' was generated successfully!"
}
