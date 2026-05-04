# color name
bold='%{%B%}'
un_bold='%{%b%}'
under_lined='%{%U%}'
un_under_lined='%{%u%}'
black='%{%F{black}%}'
red='%{%F{red}%}'
green='%{%F{green}%}'
yellow='%{%F{yellow}%}'
blue='%{%F{blue}%}'
magenta='%{%F{magenta}%}'
cyan='%{%F{cyan}%}'
white='%{%F{white}%}'
default='%{%f%}'


unsetopt beep
bindkey -e


# change directory
unsetopt auto_cd
unsetopt auto_pushd
unsetopt chase_dots
unsetopt chaselinks


# completion
setopt auto_param_slash
setopt auto_remove_slash
setopt always_to_end
setopt complete_in_word
setopt glob_complete

autoload -Uz compinit
compinit -d $HOME/.zcompdump
compinit
zstyle ':completion:*:default' menu select

bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward


# expansion and globbing
unsetopt extended_glob
unsetopt case_glob
unsetopt glob_dots
setopt nomatch
setopt hist_subst_pattern
setopt magic_equal_subst


# history
setopt append_history
setopt inc_append_history
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000


# input/output
setopt interactive_comments


# job control
unsetopt bg_nice
unsetopt notify


# prompt
unsetopt prompt_bang
setopt prompt_subst

# git prompt
prompt_git()
{
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n "${branch}" ]] {
        local work_status='+'
        local work_color="${red}"
        local cache_status='+'
        local cache_color="${red}"
        if { ! git ls-files --others --exclude-standard --directory --no-empty-directory --error-unmatch -- ':/*' &> /dev/null && \
          git diff --no-ext-diff --quiet &> /dev/null; } {
            work_status='-'
            work_color="${green}"
        }
        if { git diff --no-ext-diff --cached --quiet &> /dev/null; } {
            cache_status='-'
            cache_color="${green}"
        }
        echo "${bold}${white}<${blue}${branch}${work_color}${work_status}${cache_color}${cache_status}${white}>${default}${un_bold}"
    }
}

PROMPT_PREFIX="${bold}%(?.${green}-.${red}!) ${default}${un_bold}"
PROMPT_INFO="${bold}${white}[${green}%n${yellow}@${magenta}%m${default}${un_bold}:${under_lined}%~${un_under_lined}${bold}${white}]${default}${un_bold}"
PROMPT_NEWLINE=$'\n%{\r%}'
PROMPT_SUFFIX="${bold}%(!.${red}#.${cyan}$) ${default}${un_bold}"
if (( $UID == 0 )) {
    export PROMPT="${PROMPT_PREFIX}${PROMPT_INFO}${PROMPT_NEWLINE}${PROMPT_SUFFIX}"
} else {
    export PROMPT="${PROMPT_PREFIX}${PROMPT_INFO}\$(prompt_git)${PROMPT_NEWLINE}${PROMPT_SUFFIX}"
}


# static link library
[[ -z "${BASE_LIBRARY_PATH}" ]] && export BASE_LIBRARY_PATH="$LIBRARY_PATH"
export LIBRARY_PATH="${BASE_LIBRARY_PATH}"

# dynamic link library
[[ -z "${BASE_LD_LIBRARY_PATH}" ]] && export BASE_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="${BASE_LD_LIBRARY_PATH}"

# env path
[[ -z "${BASE_PATH}" ]] && export BASE_PATH="$HOME/.bin:$PATH"
export PATH="${BASE_PATH}"


# alias
[[ -f $HOME/.alias ]] && . $HOME/.alias
