#!/bin/bash

## author: KleiberXD

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE-$0}")" && pwd)"
source "${ROOT_DIR}/scripts/help.sh"

EXEC="build"
INPUT_FILE="in.tpp"
OUTPUT_FILE="out.tpp"
EXPECTED_FILE="expected.tpp"

#  init new template cpp
function init_tpp() {
	if fileExists $1; then
		echo "Error: $1 already exists" >&2
		exit 1
	fi

	# define reference to debug.h
	local reference=$ROOT_DIR
	if isWindows; then
		partition="${reference:1:1}"
		reference="${partition^}:${reference:2}"
	fi
	local date=$(date +"%d/%m/%Y %T")

	# generate cpp template file
	cat > $1 <<-EOF
		/**
		*  Generated by tpp tool
		*  File: $1
		*  Created: $date
		**/

		#include <bits/stdc++.h>
		using namespace std;

		// remove this code before your submission
		#include "${reference}/debug.h"

		int main() {
		    // do not remove this code if you use cin or cout
		    ios::sync_with_stdio(false);
		    cin.tie(0);

		    return 0;
		}
	EOF
	if errorExists; then
		echo "Error: $1 init failed" >&2
		exit 1
	fi

	# generate input file in.tpp
	touch $INPUT_FILE
	# generate ouput file out.tpp
	touch $OUTPUT_FILE
	# generate test file test.tpp
	touch $EXPECTED_FILE
}

# build cpp file
function build_tpp() {
	if ! fileExists $1; then
		echo "Error: $1 file does not exist" >&2
	    exit 1
	fi

	g++ -o $EXEC $1
	if errorExists; then
		echo "Error: $1 compilation failed" >&2
		exit 1
	fi
}

# run cpp file with input file
function run_with_input() {
	./$EXEC < $INPUT_FILE
	if errorExists; then
		echo "Error: $1 execution with input file $INPUT_FILE failed" >&2
		exit 1
	fi
}

# run cpp file without input file
function run_without_input() {
	./$EXEC
	if errorExists; then
		echo "Error: $1 execution failed" >&2
		exit 1
	fi
}

# compile and run cpp file with/without the input file
function run_tpp() {
	if ! fileExists $1; then
		echo "Error: $1 file does not exist" >&2
		exit 1
	fi

	build_tpp $1
	if fileExists $INPUT_FILE; then
		run_with_input $1
	else
		run_without_input $1
	fi
}

 # compile, run and test cpp file ouput with the test file
function test_tpp() {
	if ! fileExists $1; then
		echo "Error: $1 file does not exist" >&2
		exit 1
	fi

	if ! fileExists $EXPECTED_FILE; then
		echo "Error: $OUPUTPUT_FILE file does not exist" >&2
		exit 1
	fi

	run_tpp $1 > $OUTPUT_FILE
	diff $EXPECTED_FILE $OUTPUT_FILE --color
	if errorExists; then
		echo diff $EXPECTED_FILE $OUTPUT_FILE >&2
		echo "$1 test FAILED"
		exit 1
	fi
	echo "$1 test PASSED!"
}

function fileExists() {
	if [ -f $1 ] ; then
		return 0
	else
	    return 1
	fi
}

function errorExists() {
	if [ $? -eq 1 ] ; then
		return 0
	else
		return 1
	fi
}

function isWindows() {
	local os=$(uname)
	if [[ "$os" == CYGWIN* || "$os" == MINGW* ]] ; then
		return 0
	else
		return 1
	fi
}

function tpp() {
	local commands=($@)
	help_tpp ${commands[@]}

	if [ "${#commands[@]}" -ne 2 ]; then
		echo "Error: two arguments are necessary, use the -h flag for more details" >&2
		exit 1
	fi

	local command="${commands[0]}"
	local filename="${commands[1]}"
	local extension="${filename##*.}"

	if [ $extension == $filename ]; then
		filename="$filename.cpp"
	else
		if [ ! $extension == 'cpp' ]; then
			echo "Error: $filename file is not cpp" >&2
			exit 1
		fi
	fi

	if ! [[ ${filename%.*} =~ ^[0-9a-zA-Z._-]+$ ]]; then
		echo "Error: $filename invalid filename" >&2
		exit 1
	fi

	case $command in
	"init")
		init_tpp $filename
		echo "$filename was initialized successfully!"
		;;
	"build")
		build_tpp $filename
	    echo "$filename was compiled successfully!"
		;;
	"run")
		run_tpp $filename;;
	"test")
		test_tpp $filename
		;;
	*)
		echo "Error: Invalid arguments, use the -h flag for more details" >&2
	;;
	esac
}

tpp $@
