# dotfiles

## Setup

```sh
curl -sSfL https://raw.githubusercontent.com/TomoyaFukui/dotfiles/main/install.sh | sh
```

## Powerline prompt on macOS

Zinit installs powerline-go from its GitHub release when zsh starts.
Install the font separately on macOS:

```sh
brew install --cask font-jetbrains-mono-nerd-font
```

In iTerm2, open **Settings → Profiles → Text** and select
**JetBrainsMono Nerd Font Mono**. If the profile uses a separate non-ASCII font,
select the same font there so that Powerline icons use it too. Open a new tab
to load the zsh configuration.
