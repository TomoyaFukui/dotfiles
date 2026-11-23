export LANG=en_US.UTF-8

# The startup files will not be run
# Doc: http://zsh.sourceforge.net/Doc/Release/Options.html#Initialisation
unsetopt GLOBAL_RCS

### PATH ###
typeset -gU PATH path
path=("${HOME}/.local/bin"(N-/) "${path[@]}")

### Homebrew ###
for brew_bin in "${commands[brew]}" /opt/homebrew/bin/brew /usr/local/bin/brew \
    "${HOME}/.linuxbrew/bin/brew" /home/linuxbrew/.linuxbrew/bin/brew; do
    if [[ -x "${brew_bin}" ]]; then
        eval "$("${brew_bin}" shellenv zsh)"
        break
    fi
done
unset brew_bin

if [[ -n "${HOMEBREW_PREFIX}" ]]; then
    path=(
        "${HOMEBREW_PREFIX}/opt/binutils/bin"(N-/)
        "${HOMEBREW_PREFIX}/opt/"{coreutils,findutils,gnu-sed,gnu-tar,grep}/libexec/gnubin(N-/)
        "${HOMEBREW_PREFIX}/opt/"{curl,openssl@1.1}/bin(N-/)
        "${HOMEBREW_PREFIX}/opt/python/libexec/bin"(N-/)
        "${path[@]}"
    )
    manpath=(
        "${HOMEBREW_PREFIX}/opt/"{coreutils,findutils,gnu-sed,gnu-tar,grep}/libexec/gnuman(N-/)
        "${manpath[@]}"
    )
fi

### FPATH ###
fpath=(
    "${ZDOTDIR}/func"(N-/)
    "${ZDOTDIR}/func_comp"(N-/)
    "${ASDF_DATA_DIR:-${HOME}/.asdf}/completions"(N-/)
    "${fpath[@]}"
)

### XDG Base Directory ###
# Doc: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_DATA_HOME="${XDG_DATA_HOME:-"${HOME}/.local/share"}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-"${HOME}/.cache"}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-"/tmp/runtime-$(id -u)"}"
if [[ ! -d "${XDG_RUNTIME_DIR}" ]]; then
    command mkdir -m 700 -p -- "${XDG_RUNTIME_DIR}"
fi

### Poetry ###
if [[ -r "${XDG_DATA_HOME}/poetry/env" ]]; then
    . "${XDG_DATA_HOME}/poetry/env"
fi

### pyenv ###
export PYENV_ROOT="${PYENV_ROOT:-${HOME}/.pyenv}"
path=("${PYENV_ROOT}/bin"(N-/) "${path[@]}")
if (( ${+commands[pyenv]} )); then
    eval "$(pyenv init --path)"
fi
