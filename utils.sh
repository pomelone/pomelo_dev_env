#!/usr/bin/env bash

set -euo pipefail # Exit on command failure, undefined variable, pipe failure


COLOR_RESET='\033[0m'
COLOR_RED='\033[31m'
COLOR_GREEN='\033[32m'
COLOR_YELLOW='\033[33m'
COLOR_RED_BOLD='\033[1;31m'
COLOR_GREEN_BOLD='\033[1;32m'
COLOR_YELLOW_BOLD='\033[1;33m'


log() {
    local level="$1"
    shift

    case "${level}" in
        1) log_prefix="${COLOR_RED_BOLD}Error: " ;;
        2) log_prefix="${COLOR_YELLOW_BOLD}Warn: " ;;
        3) log_prefix="${COLOR_GREEN_BOLD}==> " ;;
        *) log_prefix="${COLOR_RESET}" ;;
    esac
    echo -e "${log_prefix}$*${COLOR_RESET}"
}


log_error() {
    log 1 "$@"
}


log_warning() {
    log 2 "$@"
}


log_ok() {
    log 3 "$@"
}


log_info() {
    log 4 "$@"
}


ask_yes_no() {
    local prompt="$1"
    local default_reply='N'
    local reply

    while true; do
        echo -ne "${prompt} (Y/N): "
        read reply
        [[ -z "${reply}" ]] && reply="${default_reply}"
        case "${reply}" in
            [Yy]) return 0 ;;
            [Nn]) return 1 ;;
            *) log_warning "Invalid input, please enter Y or N." ;;
        esac
    done
}


ask() {
    local prompt="$1"
    echo -ne "${prompt} "
}


backup_file() {
    local file_name="$1"
    local backup_name="${file_name}.back"
    if [[ -f ${file_name} ]] && ask_yes_no "Backup ${file_name} file?"; then
        mv ${file_name} ${backup_name}
        log_info "Backup ${file_name} to ${backup_name}"
    fi
}


check_command() {
    local cmd="$1"
    # if command -v ${cmd} &> /dev/null; then
    if which ${cmd} &> /dev/null; then
        return 0
    fi
    log_warning "Command [${cmd}] not found!"
    return 1
}

pkg_install() {
    local pkg_manager="$1"
    shift
    local pkg_prefix=''
    [[ $(id -u) -eq 0 ]] && pkg_prefix='sudo'

    log_info "Start installing $@ ..."
    case "${pkg_manager}" in
        brew) brew install "$@" ;;
        apt) ${pkg_prefix} apt install "$@" ;;
        yum) ${pkg_prefix} yum install "$@" ;;
        dnf) ${pkg_prefix} dnf install "$@" ;;
        pacman) ${pkg_prefix} pacman -S "$@" ;;
        zypper) ${pkg_prefix} zypper install "$@" ;;
        *) log_error "${pkg_manager} not support!"; return 1 ;;
    esac
}
