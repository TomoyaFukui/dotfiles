### Zinit ###
# Repo: https://github.com/zdharma/zinit
declare -A ZINIT
ZINIT[HOME_DIR]="${XDG_DATA_HOME}/zsh/plugin/zinit"

# Keep the shell usable if the initial clone fails.
if [[ ! -r "${ZINIT[HOME_DIR]}/bin/zinit.zsh" ]]; then
    command git clone 'https://github.com/zdharma-continuum/zinit' "${ZINIT[HOME_DIR]}/bin" ||
        return 0
fi
. "${ZINIT[HOME_DIR]}/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

alias zinit-update='zinit update --all && zinit self-update && zinit compile --all'

### Plugins ###
# GitHub release asset names use Go's OS and architecture names.
load_powerline_go() {
    local platform arch asset
    case "${OSTYPE}" in
        darwin*) platform=darwin ;;
        linux*) platform=linux ;;
        *) return 0 ;;
    esac
    case "$(uname -m)" in
        arm64|aarch64) arch=arm64 ;;
        x86_64|amd64) arch=amd64 ;;
        *) return 0 ;;
    esac
    asset="powerline-go-${platform}-${arch}"
    zinit ice as'program' from'gh-r' ver'v1.26' bpick"${asset}" \
        mv"${asset} -> powerline-go" pick'powerline-go'
    zinit light justjanne/powerline-go
}
load_powerline_go
unfunction load_powerline_go

if (( ${+commands[dircolors]} )); then
    zinit ice wait='1' lucid \
        atclone='dircolors -b dircolors.256dark > color.zsh' \
        atpull='%atclone' \
        pick='color.zsh' \
        nocompile='!'
    zinit light seebi/dircolors-solarized
fi

zinit ice wait='0' lucid \
    atclone='
        . ./fast-syntax-highlighting.plugin.zsh
        fast-theme -q XDG:solarized-dark
    ' \
    atinit='zicompinit; zicdreplay'
zinit light 'zdharma-continuum/fast-syntax-highlighting'

zinit ice wait='0' lucid \
    pick='zsh-history-substring-search.zsh' \
    atload="
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
        bindkey -M vicmd 'k' history-substring-search-up
        bindkey -M vicmd 'j' history-substring-search-down
    "
zinit light zsh-users/zsh-history-substring-search

zinit ice wait='0' lucid \
    atload="
        _zsh_autosuggest_start
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'
    "
zinit light zsh-users/zsh-autosuggestions

zinit ice wait='0' blockf lucid
zinit light zsh-users/zsh-completions

zinit ice wait='0' lucid
zinit light hlissner/zsh-autopair

zinit ice wait='0' lucid \
    atload="
        bindkey '^G' anyframe-widget-cd-ghq-repository
        alias fcdr='anyframe-widget-cdr'
        alias fh='anyframe-widget-put-history'
        alias fkill='anyframe-widget-kill'
    "
zinit light mollifier/anyframe

zinit ice wait='0' lucid \
    atinit='export FORGIT_GI_REPO_LOCAL="${XDG_DATA_HOME}/zsh/plugin/forgit"' \
    run-atpull atpull='forgit::ignore::update' \
    atload="
        alias grst='gcf'
        alias gst='gss'
    "
zinit light wfxr/forgit

zinit ice wait='0' lucid \
    atload="alias cdu='cd-gitroot'"
zinit light mollifier/cd-gitroot

zinit ice wait='0' lucid \
    atinit='. "$ZDOTDIR/.zshrc_lazy"'
zinit light zdharma-continuum/null
