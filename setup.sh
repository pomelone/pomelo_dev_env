#!/usr/bin/env bash

set -euo pipefail # Exit on command failure, undefined variable, pipe failure

source ./utils.sh


OS=$(uname -s)
OS_ID='unknown'
PKG_MANAGER='unknown'


check_os() {
    log_ok 'Checking OS ...'

    case "${OS}" in
        Linux)
            [[ -f /etc/os-release ]] && . /etc/os-release && OS_ID="${ID}"
            case "${OS_ID}" in
                debian|ubuntu) PKG_MANAGER='apt' ;;
                rhel|centos|fedora|almalinux|rocky) PKG_MANAGER='dnf' ;;   # not yum
                arch|manjaro) PKG_MANAGER='pacman' ;;
                suse|opensuse*) PKG_MANAGER='zypper' ;;
                *) log_error "OS: ${OS}(${OS_ID}) not support!"; exit 1 ;;
            esac
            ;;
        Darwin)
            OS_ID='Mac'
            PKG_MANAGER='brew'
            ;;
        *) log_error "OS: ${OS} not support!"; exit 1 ;;
    esac

    if ! check_command ${PKG_MANAGER}; then
        log_error "Need to install extra commands via ${PKG_MANAGER}."
        exit 1
    fi

    log_ok "OS: ${OS}(${OS_ID}); Package Manager: ${PKG_MANAGER}"
}


alias_config() {
    ask_yes_no 'Setup alias?' || return 0
    log_ok 'Setting alias ...'

    # backup ~/.alias
    backup_file ~/.alias

    # init ~/.alias
    case "${OS}" in
        Linux)
            log_info 'Copying to ~/.alias'
            cp -f ./alias_linux ~/.alias
            ;;
        Darwin)
            log_info 'Copying to ~/.alias'
            cp -f ./alias_mac ~/.alias
            check_command trash || pkg_install ${PKG_MANAGER} trash
            ;;
        *) log_error "OS: ${OS} not support!"; exit 1 ;;
    esac

    # create ~/.Trash directory
    if [[ ! -d ~/.Trash ]]; then
        log_info 'Create ~/.Trash directory.'
        mkdir ~/.Trash
    fi

    log_ok 'Setup alias complete.'
}


shell_config() {
    ask_yes_no 'Setup shell?' || return 0
    log_ok 'Setting shell ...'

    local running=true
    local shell_name
    local shell_path

    while ${running}; do
        ask 'Input the shell to setup (bash/zsh/Q):'
        read shell_name

        if [[ "${shell_name}" =~ ^[Qq]$ ]]; then
            log_error 'Setup shell failed!'
            return 0
        fi

        check_command ${shell_name} || continue
        shell_path=$(which ${shell_name})
        
        case "${shell_name}" in
            # setup bash
            bash)
                backup_file ~/.bashrc
                log_info 'Copying to ~/.bashrc'
                cp -f ./bashrc ~/.bashrc
                backup_file ~/.bash_profile
                log_info 'Copying to ~/.bash_profile'
                cp -f ./bash_profile ~/.bash_profile
                backup_file ~/.inputrc
                log_info 'Copying to ~/.inputrc'
                cp -f ./inputrc ~/.inputrc
                ask_yes_no 'Install bash-completion?' && pkg_install ${PKG_MANAGER} bash-completion
                running=false
                ;;
            # setup zsh
            zsh)
                backup_file ~/.zshrc
                log_info 'Copying to ~/.zshrc'
                cp -f ./zshrc ~/.zshrc
                backup_file ~/.zprofile
                log_info 'Copying to ~/.zprofile'
                cp -f ./zprofile ~/.zprofile
                [[ "${OS}" == 'Darwin' ]] && ask_yes_no 'Install zsh-completions?' && pkg_install ${PKG_MANAGER} zsh-completions
                running=false
                ;;
            *) log_warning "Shell [${shell_name}] not matched, please try again." ;;
        esac
    done

    # change login shell
    if ask_yes_no "Change the login shell to ${shell_name}(${shell_path})?"; then
        chsh -s ${shell_path}
    fi

    log_ok 'Setup shell complete.'
}


git_config() {
    ask_yes_no 'Setup git?' || return 0
    log_ok 'Setting git ...'

    # check git, git-lfs
    check_command git || pkg_install ${PKG_MANAGER} git
    check_command git-lfs || pkg_install ${PKG_MANAGER} git-lfs

    local GIT_STORE='store'
    case "${OS}" in
        Linux)
            if ! check_command pass; then
                case "${OS_ID}" in
                    suse|opensuse*)  pkg_install ${PKG_MANAGER} password-store ;;
                    *) pkg_install ${PKG_MANAGER} pass ;;
                esac
            fi
            if ! check_command pass-git-helper; then
                case "${OS_ID}" in
                    debian|ubuntu) pkg_install ${PKG_MANAGER} pass-git-helper ;;
                    suse|opensuse*) pkg_install ${PKG_MANAGER} python3-pass-git-helper ;;
                    *) log_warning 'Install pass-git-helper via python3-pip' ;;
                esac
            fi
            GIT_STORE='!pass-git-helper -m ~/.password-store/pass-git-helper/git-pass-mapping.ini $@'
            ;;
        Darwin) GIT_STORE='osxkeychain' ;;
        *) log_error "OS: ${OS} not support!"; exit 1 ;;
    esac
    log_ok "Git Credential Helper: ${GIT_STORE}"

    log_info 'Setting git global config ...'
    git config --global init.defaultBranch main
    git config --global core.autocrlf input   # true for Windows
    git config --global credential.useHttpPath true  # config match git path
    git config --global credential.helper "${GIT_STORE}"  # config credential type

    log_ok 'Setup git complete.'
}


vim_config() {
    ask_yes_no 'Setup vim?' || return 0
    log_ok 'Setting vim ...'

    # check vim
    check_command vim || pkg_install ${PKG_MANAGER} vim

    # setup ~/.vimrc
    backup_file ~/.vimrc
    log_info 'Copying to ~/.vimrc'
    cp -f ./vimrc ~/.vimrc

    log_ok 'Setup vim complete.'
}


tmux_config() {
    ask_yes_no 'Setup tmux?' || return 0
    log_ok 'Setting tmux ...'

    # check tmux
    check_command tmux || pkg_install ${PKG_MANAGER} tmux

    # setup tmux alias
    local tmux_path=$(which tmux)
    log_info "Setting tmux(${tmux_path}) alias to ~/.alias"
    [[ ! -f ~/.alias ]] && touch ~/.alias

    if ! grep -q 'tmux' ~/.alias; then
        bash ./alias_tmux.sh
    fi

    # setup ~/.tmux.conf
    backup_file ~/.tmux.conf
    log_info 'Copying to ~/.tmux.conf'
    cp -f ./tmux.conf ~/.tmux.conf

    log_ok 'Setup tmux complete.'
}


proxy_config() {
    ask_yes_no 'Setup proxy?' || return 0
    log_ok 'Setting proxy ...'

    log_info 'Setting proxy alias to ~/.alias'
    [[ ! -f ~/.alias ]] && touch ~/.alias

    if ! grep -q 'proxy' ~/.alias; then
        cat alias_proxy >> ~/.alias
    fi
    log_ok 'Setup proxy complete.'
}


# main
log_ok 'Setup Development Environment'
echo

check_os
echo

shell_config
echo

alias_config
echo

git_config
echo

vim_config
echo

tmux_config
echo

proxy_config
echo

log_ok 'Setup finished.'
echo

log_ok 'Please re-login for the settings to take effect.'
