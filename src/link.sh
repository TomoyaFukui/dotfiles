#!/usr/bin/env sh
set -eu
export LC_ALL=C
export LANG=C
IFS="$(printf " \t\nx")"

XDG_DATA_HOME="${HOME}/.local/share"
GHQ_ROOT="${XDG_DATA_HOME}/ghq"
REPO_ROOT="${GHQ_ROOT}/github.com/TomoyaFukui/dotfiles"
DOTFILES_HOME="${REPO_ROOT}/dotfiles"

cd "${DOTFILES_HOME}"

echo 'Symlinking dotfiles...'
command find . -type d | xargs -I '{}' mkdir -p "${HOME}/{}"
command find . -type f | xargs -I '{}' ln -snf "${DOTFILES_HOME}/{}" "${HOME}/{}"
echo 'Symlinking dotfiles complete.'
