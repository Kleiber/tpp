#!/usr/bin/env bash

## author: KleiberXD

set -e

# Side-by-side diff (GitHub split-view style)
show_side_by_side() {
    local expFile="${1}"
    local outFile="${2}"

    local RED_FG='\033[31m'
    local GREEN_FG='\033[32m'
    local DIM='\033[2m'
    local OFF='\033[0m'

    local w=25
    local differences=0

    local -a exp_lines=()
    local -a out_lines=()

    while IFS= read -r line || [[ -n "$line" ]]; do
        exp_lines+=("$line")
    done < "${expFile}"

    while IFS= read -r line || [[ -n "$line" ]]; do
        out_lines+=("$line")
    done < "${outFile}"

    local max=${#exp_lines[@]}
    if [[ ${#out_lines[@]} -gt ${max} ]]; then
        max=${#out_lines[@]}
    fi

    printf "  ${DIM}%4s │ %-${w}s  %4s │ %-${w}s${OFF}\n" "" "Expected" "" "Output"
    printf "  ${DIM}─────┼─$(printf '%0.s─' $(seq 1 ${w}))───────┼─$(printf '%0.s─' $(seq 1 ${w}))${OFF}\n"

    for ((i=0; i<max; i++)); do
        local ln=$((i + 1))
        local exp_l="${exp_lines[$i]:-}"
        local out_l="${out_lines[$i]:-}"
        local exp_d="${exp_l:0:${w}}"
        local out_d="${out_l:0:${w}}"

        if [[ ${i} -ge ${#exp_lines[@]} ]]; then
            differences=$((differences + 1))
            printf "  %4s   %-${w}s  ${GREEN_FG}%4d │ %-${w}s${OFF}\n" "" "" "${ln}" "${out_d}"
        elif [[ ${i} -ge ${#out_lines[@]} ]]; then
            differences=$((differences + 1))
            printf "  ${RED_FG}%4d │ %-${w}s${OFF}  %4s   %-${w}s\n" "${ln}" "${exp_d}" "" ""
        elif [[ "${exp_l}" != "${out_l}" ]]; then
            differences=$((differences + 1))
            printf "  ${RED_FG}%4d │ %-${w}s${OFF}  ${GREEN_FG}%4d │ %-${w}s${OFF}\n" "${ln}" "${exp_d}" "${ln}" "${out_d}"
        else
            printf "  ${DIM}%4d${OFF} │ %-${w}s  ${DIM}%4d${OFF} │ %-${w}s\n" "${ln}" "${exp_d}" "${ln}" "${out_d}"
        fi
    done

    if [[ ${differences} -eq 0 ]]; then
        printf "\n  ${BGreen}✓ All lines match${ColorOff}\n"
    else
        printf "\n  ${BRed}✗ ${differences} difference(s) found${ColorOff}\n"
    fi
}

diff_tpp_solution() {
    local num=""
    local name=""

    # parse args: number = case, text = solution name
    if [[ "${1}" =~ ^[0-9]+$ ]]; then
        num="${1}"
        name="${2}"
    else
        name="${1}"
    fi

    resolve_solution "${name}"

    local caseCount=$(get_case_count "${SOL_DIR}")

    if [[ ${caseCount} -eq 0 ]]; then
        echo "Error: '$(basename "${SOL_FILENAME%.*}")' solution does not contain test cases." >&2
        exit 1
    fi

    if [[ -n "${num}" ]]; then
        local outFile=$(get_output_file "${SOL_DIR}" "${num}")
        local expFile=$(get_expected_file "${SOL_DIR}" "${num}")

        if ! fileExists "${expFile}"; then
            echo "Error: expected file for case ${num} does not exist." >&2
            exit 1
        fi
        if ! fileExists "${outFile}"; then
            echo "Error: output file for case ${num} does not exist. Run 'tpp test' first." >&2
            exit 1
        fi

        show_side_by_side "${expFile}" "${outFile}"
    else
        local allMatch=true
        for i in $(seq 1 ${caseCount}); do
            local outFile=$(get_output_file "${SOL_DIR}" "${i}")
            local expFile=$(get_expected_file "${SOL_DIR}" "${i}")

            if ! fileExists "${expFile}" || ! fileExists "${outFile}"; then
                continue
            fi

            if isEmpty "${expFile}"; then
                continue
            fi

            if ! diff -q "${expFile}" "${outFile}" > /dev/null 2>&1; then
                allMatch=false
                echo -e "${BRed}Case ${i}:${ColorOff}"
                show_side_by_side "${expFile}" "${outFile}"
                echo ""
            fi
        done

        if ${allMatch}; then
            echo -e "${BGreen}All cases match${ColorOff}"
        fi
    fi
}

diff_help() {
    cat <<EOF

Show side-by-side diff between expected and actual output (GitHub-style).
Run 'tpp test' first to generate output files.

Usage:  tpp dif [case-number] [solution-name]

Without case number, shows diff for all cases.

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

diff_cmd() {
    if [[ ${#} -gt 2 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    if [[ "${1}" == "--help" ]] || [[ "${1}" == "-h" ]]; then
        diff_help
        exit 0
    fi

    diff_tpp_solution "$@"
}
