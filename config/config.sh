#!/usr/bin/env bash

## author: KleiberXD

export BRed='\033[1;31m'
export BGreen='\033[1;32m'
export ColorOff='\033[0m'

export CLI_NAME=tpp

export EXTENSION_FILE="cpp"
export BUILD="build"
export CONFIG_DIR=".tpp"
export CONFIG_FILE="config"
export INPUT_FILE="in.tpp"
export OUTPUT_FILE="out.tpp"
export EXPECTED_FILE="expected.tpp"

export VIM_DIR="${HOME}/.vim"
export VIM_PLUGIN_DIR="${VIM_DIR}/bundle"
export VIMRC_PATH="${HOME}/.vimrc"

export TPP_GITHUB=${TPP_GITHUB:-"tpp_github"}
export TPP_REPO=${TPP_REPO:-"${HOME}/tpp_repo"}
export TPP_BRANCH=${TPP_BRANCH:-"main"}

export TPP_WORKSPACE=${TPP_WORKSPACE:-"${HOME}/CodeWorkspace"}
export TPP_IDE=${TPP_IDE:-"vi"}
export TPP_TEST=${TPP_TEST:-"0"}
export TPP_FILL=${TPP_FILL:-"0"}
export TPP_VIEWS=${TPP_VIEWS:-"0"}
export TPP_GCC=${TPP_GCC:-"c++11"}
