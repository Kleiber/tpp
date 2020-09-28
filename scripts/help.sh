#!/bin/bash

## author: drwn28

source "${ROOT_DIR}/scripts/commands.sh"

TABS=()
INPUTS=()
SIZE=0

# Obtains the number of spaces between each command/flag name and
# its description, so that when displaying them they are aligned
#
# e.g.
#   Given the command "<COMMAND>" that has the following flags:
#   (a point represents a space)
#
#   flag1.......<description1>     (7 spaces)
#   flag100.....<description100>   (5 spaces)
#   flag1000....<description1000>  (4 spaces)
#
# TABS = [<7-spaces> <5-spaces> <4-spaces>]
# INPUTS = [flag1 flag100 flag1000]
#
function init_tabs() {
  TABS=()
  INPUTS=()
  case "$1" in
    "tpp") INPUTS=(${COMMANDS[@]})
        ;;
    "flag") INPUTS=(${FLAGS[@]})
        ;;
    "init") INPUTS=(${FLAGS_INIT[@]})
        ;;
    "run") INPUTS=(${FLAGS_RUN[@]})
        ;;
    "test") INPUTS=(${FLAGS_TEST[@]})
        ;;
  esac
  SIZE=$((${#INPUTS[@]}-1))

  for i in $(seq 0 $SIZE)
  do
    local input=${INPUTS[i]}
    if [[ ${#input} -ge $max_size ]]; then max_size=${#input}; fi
  done

  local col_init=$((max_size+3))
  for i in $(seq 0 $SIZE)
  do
    local tab=""
    local command_size=${#INPUTS[i]}
    local missing_spaces=$((col_init-command_size-1))
    for i in $(seq 0 ${missing_spaces}); do tab="$tab "; done
    
    TABS+=("$tab")
  done
}

# Print some text with two spaces at the beginning
function echo_with_tab() {
  echo "  ${@}"
}

# Print an empty string to break the current line
function break_line() {
  echo ""
}

# Print any text with a break line at the end
function print_with_break_line() {
  echo -e "$@\n"
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
    "run") echo_with_tab "${FLAGS_RUN[$idx]}${TABS[$idx]}${FLAGS_RUN_DESCRIPTION[$idx]}"
      ;;
    "test") echo_with_tab "${FLAGS_TEST[$idx]}${TABS[$idx]}${FLAGS_TEST_DESCRIPTION[$idx]}"
      ;;
  esac
}

# Given a command, print its flags and descriptions
function print_flags() {
  local command=$1
  init_tabs $command

  echo "Flags:"
  for i in $(seq 0 $SIZE); do print_resources $command $i; done

  break_line
}

# Given any 'command usage', print it with the correct format
function print_usage() {
  echo "Usage:"
  echo_with_tab ${@}

  break_line
}

# Given a command, print all the available sub-commands
# related to this
function print_commands() {
  local command=$1
  init_tabs $command

  echo "Available commands:"
  for i in $(seq 0 $SIZE); do print_resources $command $i; done

  break_line
}

# Print the help options available
function help_tpp() {
  local command_line=($@)
  local last_command_idx=$((${#command_line[@]}-1))

  if [ $last_command_idx -eq -1 ]; then
    echo "Error: two arguments are necessary, use the -h flag for more details" >&2
    exit 1
  fi

  if [ "${command_line[$last_command_idx]}" == "-h" ] \
        || [ "${command_line[$last_command_idx]}" == '--help' ]; then

    local prev_command_idx=$((${#command_line[@]}-2))

    # Check if the help flag appeared just after the tpp command
    if [ $prev_command_idx -eq -1 ]; then
      print_with_break_line "${TPP_DESC[@]}"
      print_usage "tpp <command>"
      print_commands "tpp"
      print_flags "flag"

      exit 0
    fi

    # Check which is the command that appeared just before the help flag
    case "${command_line[$prev_command_idx]}" in
      "init")
        print_with_break_line ${COMMANDS_DESCRIPTION[0]}
        print_usage "tpp init <filename>"
        print_flags "init"
        ;;
      "build")
        print_with_break_line ${COMMANDS_DESCRIPTION[1]}
        print_usage "tpp build <filename>"
        ;;
      "run")
        print_with_break_line ${COMMANDS_DESCRIPTION[2]}
        print_usage "tpp run <filename>"
        print_flags "run"
        ;;
      "test")
        print_with_break_line ${COMMANDS_DESCRIPTION[3]}
        print_usage "tpp test <filename>"
        print_flags "test"
        ;;
    esac

    exit 0
  fi
}
