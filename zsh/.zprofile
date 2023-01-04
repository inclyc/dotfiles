if [[ -r "${XDG_CONFIG_HOME:-"$HOME/.config"}/zsh/before/profile.zsh" ]]; then
    source "${XDG_CONFIG_HOME:-"$HOME/.config"}/zsh/before/profile.zsh"
fi

# User specific binraies, push it at the top
path=("$HOME/.local/bin" $path)

export EDITOR="code --wait"
export VISUAL="code --wait"


if [[ -r "${XDG_CONFIG_HOME:-"$HOME/.config"}/zsh/after/profile.zsh" ]]; then
    source "${XDG_CONFIG_HOME:-"$HOME/.config"}/zsh/after/profile.zsh"
fi
