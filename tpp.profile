#!/usr/bin/env bash

## tpp - competitive programming tool
## Source this file in your ~/.zshrc or ~/.bashrc

# Resolve install directory dynamically
TPP_HOME="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
export PATH="$PATH:$TPP_HOME"
export TPP_VIMRC="${TPP_HOME}/config/vimrc"

# User configuration (override in .zshrc before this line)
export TPP_WORKSPACE="${TPP_WORKSPACE:-$HOME/code}"
export TPP_IDE="${TPP_IDE:-vi}"
export TPP_TEST="${TPP_TEST:-0}"
export TPP_FILL="${TPP_FILL:-0}"
export TPP_VIEWS="${TPP_VIEWS:-0}"
export TPP_GCC="${TPP_GCC:-c++11}"
export TPP_TL="${TPP_TL:-4}"

# Github configuration
export TPP_GITHUB="${TPP_GITHUB:-tpp_github}"
export TPP_REPO="${TPP_REPO:-$HOME/tpp_repo}"
export TPP_BRANCH="${TPP_BRANCH:-main}"

# Enable Ctrl+S in terminal (prevents freeze)
stty -ixon 2>/dev/null

# Aliases
alias init="tpp init"
alias add="tpp add"
alias build="tpp build"
alias clone="tpp clone"
alias dif="tpp dif"
alias run="tpp run"
alias test="tpp test"
alias prepare="tpp prepare"
alias open="tpp open"
alias in="tpp in"
alias out="tpp out"
alias exp="tpp exp"
alias judge="tpp judge"
alias tag="tpp tag"
alias list="tpp ls"
alias submit="tpp submit"
