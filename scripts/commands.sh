#!/bin/bash

TPP_DESC="tpp is a command line that aims to help competitive programmers optimizing code compilation, testing, and debugging time."

COMMANDS=(\
"init" \
"build" \
"run" \
"test")

COMMANDS_DESCRIPTION=(\
"Create a .cpp file template with the specified name" \
"Compile the specified .cpp file" \
"Compile and run the specified .cpp file" \
"Compile, run and test the specified .cpp file")

FLAGS=(\
"-h,--help")

FLAGS_DESCRIPTION=(\
"Show help options")

FLAGS_INIT=(\
"-f,--force"
)

FLAGS_INIT_DESCRIPTION=(\
"Force the creating of the .cpp file template"
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
