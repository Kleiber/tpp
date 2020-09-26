#!/bin/bash

source "${ROOT_DIR}/scripts/commands.sh"

TAB_COMMAND=()
TAB_FLAG=()

# Number of spaces between the command name and its description
function init_command_tab() {
    local max_size=0
    for c in ${COMMANDS[@]}
    do
        if [[ ${#c} -ge $max_size ]]; then max_size=${#c}; fi
    done

    local col_init=$((max_size+2))
    for c in ${COMMANDS[@]}
    do
        local tab=""
        local command_size=${#c}
        local missing_spaces=$((col_init-command_size))
        for i in $(seq 0 ${missing_spaces}); do tab="$tab "; done
        
        TAB_COMMAND+=("$tab")
    done
}

# Number of spaces between the flag name and its description
function init_flags_tab() {
    local max_size=0
    for i in $(seq 0 ${#FLAGS[@]})
    do
        local flag=${FLAGS[i]}
        if [[ ${#flag} -ge $max_size ]]; then max_size=${#flag}; fi
    done

    local col_init=$((max_size+2))
    for i in $(seq 0 ${#FLAGS[@]})
    do
        local tab=""
        local command_size=${#FLAGS[i]}
        local missing_spaces=$((col_init-command_size))
        for i in $(seq 0 ${missing_spaces}); do tab="$tab "; done
        
        TAB_FLAG+=("$tab")
    done
}

# Print some text with two spaces at the beginning
function echo_with_tab() {
	echo "  ${@}"
}

# Given a position, print the command that is placed there
# See common.sh to be aware of the available commands
function print_command() {
	local command=${COMMANDS[$1]}
	local description=${COMMANDS_DESCRIPTION[$1]}

	echo_with_tab "${command}${TAB_COMMAND[$1]}${description}"
}

# Given a position, print the flag that is placed there
# See common.sh to be aware of the available flags
function print_flag() {
	local flag=${FLAGS[$1]}
	local description=${FLAGS_DESCRIPTION[$1]}

	echo_with_tab "${flag}${TAB_FLAG[$1]}${description}"
}

# Print the help options available
function help_tpp() {
    local command_line=($@)
    local last_command_idx=$((${#command_line[@]}-1))

    init_command_tab
    init_flags_tab

	if [ "${command_line[$last_command_idx]}" == "-h" ] \
            || [ "${command_line[$last_command_idx]}" == '--help' ]; then

        local prev_command_idx=$((${#command_line[@]}-2))

        # Check if the help flag appeared just after the tpp command
        if [ $prev_command_idx -eq -1 ]; then
            echo "${TPP_DESC[@]}"
            echo -e "\nUsage:"
            echo_with_tab "tpp <command>"

            echo -e "\nAvailable commands:"
            for i in $(seq 0 ${#COMMANDS[@]}); do print_command $i; done

            echo -e "Flags:"
            for i in $(seq 0 ${#FLAGS[@]}); do print_flag $i; done

            exit 0
        fi

        # check which is the command that appeared just before the help flag
        case "${command_line[$prev_command_idx]}" in
            "init")
                echo ${COMMANDS_DESCRIPTION[0]}
                echo -e "\nUsage:"
                echo_with_tab "tpp init <filename>"
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
                echo ${COMMANDS_DESCRIPTION[2]}
                echo -e "\nUsage:"
                echo_with_tab "tpp test <filename>"
                ;;
        esac

        echo ""
		exit 0
	fi
}
