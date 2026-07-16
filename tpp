#!/usr/bin/env bash

## author: KleiberXD
## tpp - competitive programming tool

set -e

export TPP_DIR="$(cd "$(dirname "${BASH_SOURCE-$0}")" && pwd)"

# Load configuration and utilities
source "${TPP_DIR}/config/config.sh"
source "${TPP_DIR}/config/template.sh"
source "${TPP_DIR}/common/util.sh"
source "${TPP_DIR}/common/common.sh"

# Load commands
source "${TPP_DIR}/commands/add.sh"
source "${TPP_DIR}/commands/build.sh"
source "${TPP_DIR}/commands/clone.sh"
source "${TPP_DIR}/commands/diff.sh"
source "${TPP_DIR}/commands/expected.sh"
source "${TPP_DIR}/commands/init.sh"
source "${TPP_DIR}/commands/input.sh"
source "${TPP_DIR}/commands/judge.sh"
source "${TPP_DIR}/commands/list.sh"
source "${TPP_DIR}/commands/open.sh"
source "${TPP_DIR}/commands/output.sh"
source "${TPP_DIR}/commands/prepare.sh"
source "${TPP_DIR}/commands/run.sh"
source "${TPP_DIR}/commands/submit.sh"
source "${TPP_DIR}/commands/tag.sh"
source "${TPP_DIR}/commands/test.sh"

tpp_version() {
    local version=$(cat "${TPP_DIR}/config/VERSION")
    echo "${CLI_NAME} version ${version}"
}

tpp_help() {
    cat <<EOF

tpp is a command line tool that helps competitive programmers optimize
code compilation, testing, and debugging time.

 Find more information at: https://github.com/Kleiber/tpp

Usage:  tpp COMMAND [OPTIONS]

Commands:
  add       Add a new test case (input + expected pair)
  build     Compile the .cpp file
  clone     Clone an existing solution as a starting point
  dif       Show side-by-side diff between expected and output
  exp       Open expected file
  in        Open input file
  init      Init a new solution
  judge     Set the judge name
  ls        List all solutions in workspace
  open      Open .cpp file in editor
  out       Open output file
  prepare   Generate submission file (strips debug references)
  run       Compile and run (interactive or with input file)
  submit    Submit solution to github repository
  tag       Set the tag name
  test      Compile, run and test all cases

Options:
  -h, --help      Show more information about command
  -v, --version   Show the tpp version information

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

tpp_cmd() {
    local command="${1}"

    case ${command} in
        add)       shift; add_cmd "$@" ;;
        build)     shift; build_cmd "$@" ;;
        clone)     shift; clone_cmd "$@" ;;
        dif)       shift; diff_cmd "$@" ;;
        exp)       shift; expected_cmd "$@" ;;
        in)        shift; input_cmd "$@" ;;
        init)      shift; init_cmd "$@" ;;
        judge)     shift; judge_cmd "$@" ;;
        ls)        shift; list_cmd "$@" ;;
        open)      shift; open_cmd "$@" ;;
        out)       shift; output_cmd "$@" ;;
        prepare)   shift; prepare_cmd "$@" ;;
        run)       shift; run_cmd "$@" ;;
        submit)    shift; submit_cmd "$@" ;;
        tag)       shift; tag_cmd "$@" ;;
        test)      shift; test_cmd "$@" ;;
        -v|--version) tpp_version ;;
        -h|--help|*) tpp_help ;;
    esac
}

tpp_cmd "$@"
