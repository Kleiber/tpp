#!/usr/bin/env bash

## author: KleiberXD

set -e

export TPP_DIR="$(cd "$(dirname "${BASH_SOURCE-$0}")" && pwd)"

source ${TPP_DIR}/config/config.sh
source ${TPP_DIR}/config/template.sh

source ${TPP_DIR}/common/common.sh
source ${TPP_DIR}/common/util.sh

source ${TPP_DIR}/commands/build.sh
source ${TPP_DIR}/commands/init.sh
source ${TPP_DIR}/commands/list.sh
source ${TPP_DIR}/commands/prepare.sh
source ${TPP_DIR}/commands/run.sh
source ${TPP_DIR}/commands/submit.sh
source ${TPP_DIR}/commands/tag.sh
source ${TPP_DIR}/commands/test.sh

source ${TPP_DIR}/commands/judge.sh
source ${TPP_DIR}/commands/open.sh
source ${TPP_DIR}/commands/input.sh
source ${TPP_DIR}/commands/output.sh
source ${TPP_DIR}/commands/expected.sh

source ${TPP_DIR}/commands/install.sh

tpp_version() {
    local tpp_version=$(cat ${TPP_DIR}/config/VERSION)
    echo "${CLI_NAME} version ${tpp_version}"
}

tpp_help() {
    cat <<EOF

tpp tool is a command line that aims to help competitive programmers optimizing
code compilation, testing, and debugging time.

 Find more information at: https://github.com/Kleiber/tpp

Usage:  kad COMMAND [OPTIONS]

Commands:
  build     Compile the .cpp file into the solution
  exp       Open expected file into the solution
  init      Init a new solution with the specified name
  in        Open input file into the solution
  install   Install configuration to Vim editor
  judge     Set a judge name value to the solution
  ls        List all solutions in your workspace
  open      Open .cpp file into the solution
  out       Open output file into the solution
  prepare   Generate and test a new file without the debug references from the .cpp file into the solution
  run       Compile and run the .cpp file into the solution
  submit    Submit solution to github repository 
  tag       Set a tag name value to the solution
  test      Compile, run and test the .cpp file into the solution

Options:
  -h, --help      Show more information about command
  -v, --version   Show the tpp version information

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

tpp_cmd() {
    local command=${1}

    case ${command} in
        build)
            shift
            build_cmd ${@}
            ;;
        exp)
            shift
            expected_cmd ${@}
            ;;
        init)
            shift
            init_cmd ${@}
            ;;
        in)
            shift
            input_cmd ${@}
            ;;
        install)
            shift
            install_cmd ${@}
            ;;
        judge)
            shift
            judge_cmd ${@}
            ;;
        ls)
            shift
            list_cmd ${@}
            ;;
        open)
            shift
            open_cmd ${@}
            ;;
        out)
            shift
            output_cmd ${@}
            ;;
        prepare)
            shift
            prepare_cmd ${@}
            ;;
        run)
            shift
            run_cmd ${@}
            ;;
        submit)
            shift
            submit_cmd ${@}
            ;;
        test)
            shift
            test_cmd ${@}
            ;;
        tag)
            shift
            tag_cmd ${@}
            ;;
        --version | -v)
            tpp_version
            ;;
        --help | -h | *)
            tpp_help
            ;;
    esac
}

tpp_cmd ${@}
