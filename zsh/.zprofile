if [[ -r "${XDG_DATA_HOME:-"$HOME/.local/share"}/zsh/local/before/profile.zsh" ]]; then
    source "${XDG_DATA_HOME:-"$HOME/.local/share"}/zsh/local/before/profile.zsh"
fi

# User specific binraies, push it at the top
path=("$HOME/.local/bin" $path)

if [[ -r "${XDG_DATA_HOME:-"$HOME/.local/share"}/zsh/local/after/profile.zsh" ]]; then
    source "${XDG_DATA_HOME:-"$HOME/.local/share"}/zsh/local/after/profile.zsh"
fi
