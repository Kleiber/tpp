#!/bin/bash

source "${ROOT_DIR}/scripts/commands.sh"

TABS=()

# Number of spaces between the command name and its description
function init_tabs() {
    TABS=()
    local inputs=()
    case "$1" in
        "tpp") inputs=(${COMMANDS[@]})
            ;;
        "flag") inputs=(${FLAGS[@]})
            ;;
        "init") inputs=(${FLAGS_INIT[@]})
            ;;
        "test") inputs=(${FLAGS_TEST[@]})
            ;;
    esac

    for i in $(seq 0 ${#inputs[@]})
    do
        local input=${inputs[i]}
        if [[ ${#input} -ge $max_size ]]; then max_size=${#input}; fi
    done

    local col_init=$((max_size+2))
    for i in $(seq 0 ${#inputs[@]})
    do
        local tab=""
        local command_size=${#inputs[i]}
        local missing_spaces=$((col_init-command_size))
        for i in $(seq 0 ${missing_spaces}); do tab="$tab "; done
        
        TABS+=("$tab")
    done
}

# Print some text with two spaces at the beginning
function echo_with_tab() {
	echo "  ${@}"
}

# Given a position and the type of the resource, print the
# command that is placed there
# See common.sh to be aware of the available commands
function print_resources() {
    local type_resource=$1
    local idx=$2
    case "$type_resource" in
        "tpp") echo_with_tab "${COMMANDS[$idx]}${TABS[$idx]}${COMMANDS_DESCRIPTION[$idx]}"
            ;;
        "flag") echo_with_tab "${FLAGS[$idx]}${TABS[$idx]}${FLAGS_DESCRIPTION[$idx]}"
            ;;
        "init") echo_with_tab "${FLAGS_INIT[$idx]}${TABS[$idx]}${FLAGS_INIT_DESCRIPTION[$idx]}"
            ;;
        "test") echo_with_tab "${FLAGS_TEST[$idx]}${TABS[$idx]}${FLAGS_TEST_DESCRIPTION[$idx]}"
            ;;
    esac
}

# Print the help options available
function help_tpp() {
    local command_line=($@)
    local last_command_idx=$((${#command_line[@]}-1))

	if [ "${command_line[$last_command_idx]}" == "-h" ] \
            || [ "${command_line[$last_command_idx]}" == '--help' ]; then

        local prev_command_idx=$((${#command_line[@]}-2))

        # Check if the help flag appeared just after the tpp command
        if [ $prev_command_idx -eq -1 ]; then
            echo "${TPP_DESC[@]}"
            echo -e "\nUsage:"
            echo_with_tab "tpp <command>"

            init_tabs "tpp"
            echo -e "\nAvailable commands:"
            for i in $(seq 0 ${#COMMANDS[@]}); do print_resources "tpp" $i; done

            init_tabs "flag"
            echo -e "Flags:"
            for i in $(seq 0 ${#FLAGS[@]}); do print_resources "flag" $i; done

            exit 0
        fi

        # Check which is the command that appeared just before the help flag
        case "${command_line[$prev_command_idx]}" in
            "init")
                echo ${COMMANDS_DESCRIPTION[0]}
                echo -e "\nUsage:"
                echo_with_tab "tpp init <filename>"

                init_tabs "flag"
                echo -e "\nFlags:"
                for i in $(seq 0 ${#FLAGS_INIT[@]}); do print_resources "init" $i; done
                ;;
            "build")
                echo ${COMMANDS_DESCRIPTION[1]}
                echo -e "\nUsage:"
                echo_with_tab "tpp build <filename>"
                ;;
            "run")
                echo ${COMMANDS_DESCRIPTION[2]}
                echo -e "\nUsage:"
                echo_with_tab "tpp run <filename>"
                ;;
            "test")
                echo ${COMMANDS_DESCRIPTION[3]}
                echo -e "\nUsage:"
                echo_with_tab "tpp test <filename>"

                init_tabs "test"
                echo -e "\nFlags:"
                for i in $(seq 0 ${#FLAGS_TEST[@]}); do print_resources "test" $i; done
                ;;
        esac

        exit 0
	fi
}
