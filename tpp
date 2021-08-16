#!/usr/bin/env bash

## author: KleiberXD

set -e

export TPP_DIR="$(cd "$(dirname "${BASH_SOURCE-$0}")" && pwd)"

source ${TPP_DIR}/config/config.sh

source ${TPP_DIR}/common/common.sh
source ${TPP_DIR}/common/util.sh

source ${TPP_DIR}/commands/build.sh
source ${TPP_DIR}/commands/init.sh
source ${TPP_DIR}/commands/list.sh
source ${TPP_DIR}/commands/prepare.sh
source ${TPP_DIR}/commands/run.sh
source ${TPP_DIR}/commands/submit.sh
source ${TPP_DIR}/commands/test.sh

source ${TPP_DIR}/commands/open.sh
source ${TPP_DIR}/commands/input.sh
source ${TPP_DIR}/commands/output.sh
source ${TPP_DIR}/commands/expected.sh

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
  init      Init a new solution with the specified name
  list      List all solutions in your workspace
  prepare   Generate and test a new file without the debug references from the .cpp file into the solution
  run       Compile and run the .cpp file into the solution
  submit    Submit solution to github repository 
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
        expected)
            shift
            expected_cmd ${@}
            ;;
        init)
            shift
            init_cmd ${@}
            ;;
        input)
            shift
            input_cmd ${@}
            ;;
        list)
            shift
            list_cmd ${@}
            ;;
        open)
            shift
            open_cmd ${@}
            ;;
        output)
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
        --version | -v)
            tpp_version
            ;;
        --help | -h | *)
            tpp_help
            ;;
    esac
}

tpp_cmd ${@}
