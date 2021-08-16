#!/bin/bash

## author: KleiberXD

function fileExists() {
  if [ -f $1 ] ; then
    return 0
  fi
  return 1
}

function dirExists() {
  if [ -d $1 ] ; then
    return 0
  fi
  return 1
}

function errorExists() {
  if [ $? -eq 1 ] ; then
    return 0
  fi
  return 1
}

function isLinux() {
  local os=$(uname)
  if [[ "$os" == Linux* ]] ; then
    return 0
  fi
  return 1
}

function isWindows() {
  local os=$(uname)
  if [[ "$os" == CYGWIN* || "$os" == MINGW* ]] ; then
    return 0
  fi
  return 1
}

function isMac() {
  local os=$(uname)
  if [[ "$os" == Darwin* ]] ; then
    return 0
  fi
  return 1
}

function isValidName() {
  if ! [[ $1 =~ ^[0-9a-zA-Z]+[0-9a-zA-Z._-]*$ ]]; then
    return 0
  fi
  return 1
}

function isEmpty() {
  grep -q '[^[:space:]]' $1
  if errorExists; then
    return 0
  fi
  return 1
}
