#! /bin/bash
# Sourced by the remote shell when connecting via vssh.

[ -f ~/.bashrc ] && . ~/.bashrc

vterm_printf() {
    if [ -n "$TMUX" ] && { [ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ]; }; then
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
}

vterm_exec_command() {
    vterm_printf "51;E${*}"
}

e() {
    while [ $# -gt 0 ]; do
        vterm_exec_command "find-file $(printf '"%s"' "$1")"
        shift
    done
}

vterm_rename() {
    local prompt="\w\$"
    local PROMPT_DIRTRIM=6
    vterm_exec_command "$(
        printf '%s "%s"' \
               "my-x-vterm-rename" \
               "$(printf "%s %s" \
                         "${prompt@P}" \
                         "$(history 1 | sed -E 's/ +[0-9]+ +//')")"
    )"
}

trap vterm_rename DEBUG
PROMPT_COMMAND="vterm_prompt_end${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
