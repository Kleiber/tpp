#!/bin/bash

## author: KleiberXD

function fileExists() {
    [ -f "$1" ]
}

function dirExists() {
    [ -d "$1" ]
}

function isLinux() {
    local os=$(uname)
    [[ "$os" == Linux* ]]
}

function isWindows() {
    local os=$(uname)
    [[ "$os" == CYGWIN* || "$os" == MINGW* ]]
}

function isMac() {
    local os=$(uname)
    [[ "$os" == Darwin* ]]
}

function isValidName() {
    [[ "$1" =~ ^[0-9a-zA-Z]+[0-9a-zA-Z._-]*$ ]]
}

function isEmpty() {
    ! grep -q '[^[:space:]]' "$1"
}
