### History ###
HISTFILE="${XDG_DATA_HOME}/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
autoload -Uz add-zsh-hook
add-zsh-hook preexec optimize_history_preexec
add-zsh-hook precmd optimize_history_precmd
optimize_history_preexec() {
    OPTIMIZE_HISTORY_CALLED=1
}
optimize_history_precmd() {
    local -r exit_code="$?"
    # Exit Code 130: Script terminated by Ctrl-C
    if [[ ! ${exit_code} =~ ^(0|130)$ ]] && \
        [[ "${OPTIMIZE_HISTORY_CALLED}" -eq 1 ]]; then
        # BSD || GNU
        command sed -i '' '$d' "${HISTFILE}" 2>/dev/null || \
            command sed -i '$d' "${HISTFILE}"
    fi
    unset OPTIMIZE_HISTORY_CALLED
}

### alias ###
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias c='clear'
alias g='git status'
alias sudo='sudo -E '

# Repo: https://github.com/eza-community/eza
if (( ${+commands[eza]} )); then
    alias ls='eza --group-directories-first --icons --classify'
    alias la='eza -a --group-directories-first --icons --classify'
    alias ll='eza -hal --group-directories-first --icons --classify'
    alias tree='eza --tree --group-directories-first --icons --classify -I "node_modules"'
fi

### Options ###
# Doc: http://zsh.sourceforge.net/Doc/Release/Options.html
# Changing Directories
setopt AUTO_CD
# Completion
setopt ALWAYS_LAST_PROMPT
setopt AUTO_LIST
setopt AUTO_MENU
setopt AUTO_PARAM_KEYS
setopt AUTO_PARAM_SLASH
setopt LIST_PACKED
# History
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
# Input/Output
setopt CORRECT
setopt INTERACTIVE_COMMENTS
# Expansion and Globbing
setopt EXTENDED_GLOB
setopt GLOBDOTS
setopt MAGIC_EQUAL_SUBST
setopt PRINT_EIGHT_BIT

### Completion ###
bindkey '^[[Z' reverse-menu-complete
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion::complete:*' use-cache true
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

### cdr ###
# Doc: http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Recent-Directories
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "${XDG_DATA_HOME}/zsh/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-max 100
zstyle ':chpwd:*' recent-dirs-pushd true

### zsh line editor ###
# Doc: http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
export KEYTIMEOUT=1
bindkey -v
# like bindkey -e (emacs)
bindkey -M viins '\er' history-incremental-pattern-search-forward
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^D' delete-char-or-list
bindkey -M viins '^E' end-of-line
bindkey -M viins '^N' down-line-or-history
bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^Y' yank
# Change the cursor between 'Line' and 'Block' shape
function zle-keymap-select zle-line-init zle-line-finish {
    case "${KEYMAP}" in
        main|viins)
            printf '\033[6 q' # line cursor
            ;;
        vicmd)
            printf '\033[2 q' # block cursor
            ;;
    esac
}
zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

if (( ${+commands[pyenv]} )); then
    eval "$(pyenv init - zsh)"
fi

PROMPT='%F{cyan}%~%f %# '

### Zinit ###
# Repo: https://github.com/zdharma/zinit
. "${XDG_CONFIG_HOME}/zsh/plugin/zinit/zinit.zsh"

if (( ! ${+functions[zinit]} )); then
    autoload -Uz compinit
    compinit
    . "${ZDOTDIR}/.zshrc_lazy"
fi

powerline_bin="${ZINIT[PLUGINS_DIR]:-${XDG_DATA_HOME}/zsh/plugin/zinit/plugins}/justjanne---powerline-go/powerline-go"
if [[ ! -x "${powerline_bin}" ]]; then
    powerline_bin="${commands[powerline-go]}"
fi
if [[ -x "${powerline_bin}" ]]; then
    powerline_precmd() {
        local -r exit_code=$?
        PS1="$(
            "${powerline_bin}" \
                -error "${exit_code}" \
                -shell zsh \
                -mode patched \
                -newline \
                -priority 'root,user,ssh,perms,git-branch,git-status,exit,cwd-path' \
                -path-aliases '~/.local/share/ghq=@ghq'
        )"
    }
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd powerline_precmd
fi
