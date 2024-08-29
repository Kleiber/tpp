#!/usr/bin/env bash

## author: KleiberXD

set -e

function install_tpp() {
    if dirExists ${VIM_PLUGIN_DIR}; then
        echo "There is already an installation!"
        exit 0
    fi

    tppDir=$(dirname $0)

    local vundlePlugin="Vundle.vim"
    local savePlugin="vim-auto-save"
    local bashFilePath=""

    # copy vimrc file
    vimrcLocalPath="${tppDir}/config/vimrc"
    cp ${vimrcLocalPath} ${VIMRC_PATH}

    # install plugins
    mkdir -p ${VIM_PLUGIN_DIR}

    vundlePluginPath="${VIM_PLUGIN_DIR}/${vundlePlugin}"
    git clone https://github.com/VundleVim/Vundle.vim.git ${vundlePluginPath}

    savePluginPath="${VIM_PLUGIN_DIR}/${savePlugin}"
    git clone https://github.com/907th/vim-auto-save.git ${savePluginPath}

    # set enviroment variables
    if isMac; then
        bashFilePath="${HOME}/.zshrc"
    else
        bashFilePath="${HOME}/.bashrc"
    fi

    echo "alias init='tpp init'" >> ${bashFilePath}
    echo "alias open='tpp open'" >> ${bashFilePath}
    echo "alias build='tpp build'" >> ${bashFilePath}
    echo "alias run='tpp run'" >> ${bashFilePath}
    echo "alias prepare='tpp prepare'" >> ${bashFilePath}
}

install_help() {
    cat <<EOF

Install configuration to Vim editor

Usage:  tpp install

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

install_cmd() {
    local argument=${1}
    case ${argument} in
        --help | -h)
            install_help
            ;;
        *)
            install_tpp
            ;;
    esac
}
