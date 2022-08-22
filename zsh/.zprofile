# Login shell profile not shared between different platforms
if [[ -r "${XDG_DATA_HOME:-"$HOME/.local/share"}/zsh/local/profile.zsh" ]]; then
    source "${XDG_DATA_HOME:-"$HOME/.local/share"}/zsh/local/profile.zsh"
fi


# User specific binraies, push it at the top
path=("$HOME/.local/bin" $path)
