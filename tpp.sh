#!/bin/bash

## author: KleiberXD

exec="build"
input_file="in.in"
ouput_file="out.out"

# the command line help
function help_tpp() {
	if [ "$1" == "-h" ] || [ "$1" == '--help' ]; then
		echo "Usage: $0 {init|build|run} [filename|filename.cpp]" >&2
		echo "   -h, --help      show help options"
	fi
}

#  init new template cpp 
function init_tpp() {
	if [ -f $1 ]; then
		echo "Error: $1 already exists" >&2
		exit 1
	else
		cat > $1 <<-EOF
		// author: KleiberXD
		// file: $1

		#include <bits/stdc++.h>
		using namespace std;

		// remove this code before your submission
		#include "debug.h"

		int main() { 
		    // do not remove this code if you use cin or cout
		    ios::sync_with_stdio(false);
		    cin.tie(0);

		    return 0;
		}
		EOF
		if [ $? -eq 1 ]; then
	   		echo "Error: $1 init failed" >&2
			exit 1
	    fi
	    echo "$1 was initialized successfully!"
	fi	
}

# build cpp file
function build_tpp() {
	if [ -f $1 ]; then   
	    run=$(g++ -o $exec $1)
	    if [ $? -eq 1 ]; then
			echo "Error: $1 compilation failed" >&2
			exit 1
	    fi
	    echo "$1 was compiled successfully!"
	else
	    echo "Error: $1 file does not exist" >&2
	    exit 1
	fi
}

# run cpp file with or without input file
function run_tpp() {
	if [ -f $1 ]; then
	    if [ -f $input_file ]; then
			./$exec<$input_file
			if [ $? -eq 1 ]; then
				echo "Error: $1 execution with input file in.in failed" >&2
				exit 1
			fi
		else
			./$exec
			if [ $? -eq 1 ]; then
	   			echo "Error: $1 execution failed" >&2
				exit 1
	    	fi
		fi
	else
	   echo "Error: $1 file does not exist" >&2
	   exit 1
	fi
}

function tpp() {	
	help_tpp $1

	if [ "$#" -ne 2 ]; then
		echo "Error: two arguments are necessary, use the -h flag for more details" >&2
		exit 1
	fi

	command="$1"
	filename="$2"
	extension="${filename##*.}"

	if [ $extension == $filename ]; then
		filename="$filename.cpp"
	else
		if ! [ $extension == 'cpp' ]; then
			echo "Error: file is not cpp" >&2
			exit 1
		fi
	fi

	case $command in
	"init")
		init_tpp $filename;;
	"build")
		build_tpp $filename;;
	"run")
		run_tpp $filename;;
	*)
		echo "Error: Invalid arguments, use the -h flag for more details" >&2
		exit 1	
	;;
	esac
}

tpp $1 $2
