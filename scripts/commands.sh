#!/bin/bash

## author: drwn28

TPP_DESC="tpp is a command line that aims to help competitive programmers optimizing code compilation, testing, and debugging time."

COMMANDS=(\
"init" \
"build" \
"run" \
"test" \
"submit")

COMMANDS_DESCRIPTION=(\
"Create a .cpp file template with the specified name" \
"Compile the specified .cpp file" \
"Compile and run the specified .cpp file" \
"Compile, run and test the specified .cpp file" \
"Create a new file to submit without the debug reference and use it inside the .cpp file")

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
