#!/usr/bin/env bash

## author: KleiberXD
## Internal constants (not user-configurable)

export BRed='\033[1;31m'
export BGreen='\033[1;32m'
export ColorOff='\033[0m'

export CLI_NAME=tpp

export EXTENSION_FILE="cpp"
export BUILD="build"
export CONFIG_DIR=".tpp"
export CONFIG_FILE="config"
export IN_EXT="in"
export OUT_EXT="out"
export EXP_EXT="exp"

# Defaults if tpp.profile not sourced (fallback)
export TPP_WORKSPACE=${TPP_WORKSPACE:-"${HOME}/code"}
export TPP_IDE=${TPP_IDE:-"vi"}
export TPP_TEST=${TPP_TEST:-"1"}
export TPP_FILL=${TPP_FILL:-"0"}
export TPP_VIEWS=${TPP_VIEWS:-"0"}
export TPP_GCC=${TPP_GCC:-"c++11"}
export TPP_TL=${TPP_TL:-"4"}
export TPP_GITHUB=${TPP_GITHUB:-"tpp_github"}
export TPP_REPO=${TPP_REPO:-"${HOME}/tpp_repo"}
export TPP_BRANCH=${TPP_BRANCH:-"main"}
export TPP_VIMRC=${TPP_VIMRC:-"${HOME}/tpp/config/vimrc"}
