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
	if [ -f $1 ]; then
		echo "Error: $1 already exists"
		exit 1
	else
		# define reference to debug.h
		local os=UNAME=$(uname)
		local reference=$ROOT_DIR
		if [[ "$UNAME" == CYGWIN* || "$UNAME" == MINGW* ]] ; then
			reference="C:/${reference:2}"
		fi
		# generate cpp template file
		cat > $1 <<-EOF
		// file: $1

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
		# generate input file in.tpp
		touch $INPUT_FILE
		# generate test file test.tpp
		touch $EXPECTED_FILE
	fi
}

# build cpp file
function build_tpp() {
	if [ -f $1 ]; then
	    g++ -o $EXEC $1
	else
	    echo "Error: $1 file does not exist"
	    exit 1
	fi
}

# run cpp file with input file
function run_with_input() {
	./$EXEC<$INPUT_FILE
	if [ $? -eq 1 ]; then
		echo "Error: $1 execution with input file $INPUT_FILE failed"
		exit 1
	fi
}

# run cpp file without input file
function run_without_input() {
	./$EXEC
	if [ $? -eq 1 ]; then
		echo "Error: $1 execution failed"
		exit 1
	fi
}

# compile and run cpp file with/without the input file
function run_tpp() {
	if [ -f $1 ]; then
		build_tpp $1
	    if [ -f $INPUT_FILE ]; then
			run_with_input $1
		else
			run_without_input $1
		fi
	else
	   echo "Error: $1 file does not exist"
	   exit 1
	fi
}

 # compile, run and test cpp file ouput with the test file
function test_tpp() {
	if [ -f $1 ]; then
	    if [ -f $TES_FILE ]; then
			run_tpp $1 > $OUTPUT_FILE
			# command diff with format
			diff $EXPECTED_FILE $OUTPUT_FILE --color
			if [ $? -eq 1 ]; then
				echo "$filename FAILED TESTS!"
				exit 1
			fi
			echo "$filename PASSED TESTS!"
		else
			echo "Error: $OUPUTPUT_FILE file does not exist"
			exit 1
		fi
	else
	   echo "Error: $1 file does not exist"
	   exit 1
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
		if ! [ $extension == 'cpp' ]; then
			echo "Error: file is not cpp"
			exit 1
		fi
	fi

	case $command in
	"init")
		init_tpp $filename
		if [ $? -eq 1 ]; then
			echo "Error: $filename init failed"
			exit 1
	    fi
		echo "$filename was initialized successfully!"
		;;
	"build")
		build_tpp $filename
	    if [ $? -eq 1 ]; then
			echo "Error: $filename compilation failed"
			exit 1
	    fi
	    echo "$filename was compiled successfully!"
		;;
	"run")
		run_tpp $filename;;
	"test")
		test_tpp $filename;;
	*)
		echo "Error: Invalid arguments, use the -h flag for more details"
		exit 1
	;;
	esac
}

tpp $@
