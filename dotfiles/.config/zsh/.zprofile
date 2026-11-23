### Docker ###
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1

### Node.js ###
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"

### Python ###
if (( ${+commands[pip]} )); then
    export PYTHONUSERBASE="${XDG_DATA_HOME}/pip"
    path=("${PYTHONUSERBASE}/bin"(N-/) "${path[@]}")
    . <(pip completion --zsh)
fi

# pyenv
# Repo: https://github.com/pyenv/pyenv
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Poetry
# Repo: https://github.com/sdispater/poetry
export POETRY_HOME="${XDG_DATA_HOME}/poetry"
path=("${POETRY_HOME}/bin"(N-/) "${path[@]}")

### Rust ###
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUST_BACKTRACE=1
path=("${CARGO_HOME}/bin"(N-/) "${path[@]}")
