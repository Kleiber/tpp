#!/bin/bash

## author: drwn28

TPP_DESC="tpp is a command line that aims to help competitive programmers optimizing code compilation, testing, and debugging time."

COMMANDS=(\
"init" \
"build" \
"run" \
"test" \
"prepare")

COMMANDS_DESCRIPTION=(\
"Init a new solution with the specified name" \
"Compile the .cpp file into the solution" \
"Compile and run the .cpp file into the solution" \
"Compile, run and test the .cpp file into the solution" \
"Generate and test a new file without the debug references from the .cpp file into the solution")

FLAGS=(\
"-h,--help")

FLAGS_DESCRIPTION=(\
"Show help options")

FLAGS_INIT=(\
"-f,--force"
)

FLAGS_INIT_DESCRIPTION=(\
"Force creation of solution"
)

FLAGS_RUN=(\
"-i,--input"
)

FLAGS_RUN_DESCRIPTION=(\
"File path that contain the test cases (default in.tpp)"
)

FLAGS_TEST=(\
"-i,--input"
"-e,--expected"
"-o,--output"
)

FLAGS_TEST_DESCRIPTION=(\
"File path that contain the test cases (default in.tpp)"
"File path that contain the expected outputs (default expected.tpp)"
"File path that will contain the generated output (default out.tpp)"
)
