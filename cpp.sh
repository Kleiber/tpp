#!/bin/bash

## author: KleiberXD

# the command line help
if [ "$1" == "-h" ] || [ "$1" == '--help' ]; then
	echo "Usage: $0 {run|init|test} [filename|filename.cpp]" >&2
	echo "   -h, --help      show help options"
	exit 0
fi

if [ "$#" -ne 2 ]; then
    echo "Error: two arguments are necessary, use the -h flag for more details" >&2
    exit 1
fi

command="$1"
filename="$2"
extension="${filename##*.}"

exec="build"
input_file="in.in"
ouput_file="in.in"

if [ $extension == $filename ]; then
	filename="$filename.cpp"
else
	if ! [ $extension == 'cpp' ]; then
		echo "Error: file is not cpp" >&2
		exit 1
	fi
fi

# build cpp g++ -o a a.cpp
if [ $command == 'run' ]; then
	if [ -f $filename ]; then
	   
	    run=$(g++ -o $exec $filename)
	   
	    if [ $? -eq 1 ]; then
			echo "Error: $filename file compilation failed" >&2
			exit 1
	    fi

	    echo "$filename was compiled successfully!"
	    exit 0
	else
	    echo "Error: $filename file does not exist" >&2
	    exit 1
	fi
fi

#  init new template cpp 
if [ $command == 'init' ]; then
	if [ -f $filename ]; then
	    echo "Error: file $filename exists" >&2
	    exit 1
	else
		cat > $filename <<-EOF
		// author: KleiberXD

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
	   		echo "Error: $filename init failed" >&2
			exit 1
	    fi

	    echo "$filename was initialized successfully!"
	    exit 0
	fi
fi

# run test cases
if [ $command == 'test' ]; then
	if [ -f $filename ]; then
	    if [ -f $input_file ]; then
	   		echo "Error: $input_file file does not exist" >&2
	   		exit 1
		fi

		./$exec<$input_file

	    if [ $? -eq 1 ]; then
	   		echo "Error: $filename test failed" >&2
			exit 1
	    fi

	   exit 0
	else
	   echo "Error: $filename file does not exist" >&2
	   exit 1
	fi
fi

echo "Error: Invalid arguments, use the -h flag for more details" >&2
exit 1
