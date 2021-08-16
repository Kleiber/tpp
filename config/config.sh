#!/usr/bin/env bash

## author: KleiberXD

export CLI_NAME=tpp

export SOLUTION_EXTENSION_FILE="cpp"
export SOLUTION_BUILD="build"
export SOLUTION_CONFIG_DIR=".tpp"
export SOLUTION_CONFIG_FILE="config"
export SOLUTION_INPUT_FILE="in.tpp"
export SOLUTION_OUTPUT_FILE="out.tpp"
export SOLUTION_EXPECTED_FILE="expected.tpp"

export TPP_WORKSPACE=${TPP_WORKSPACE:-"${HOME}/tpp_workspace"}
export TPP_GITHUB=${TPP_GITHUB:-"tpp_github"}
export TPP_REPO=${TPP_REPO:-"tpp_repo"}
export TPP_BRANCH=${TPP_BRANCH:-"tpp_branch"}
export TPP_IDE=${TPP_IDE:-"vi"}
