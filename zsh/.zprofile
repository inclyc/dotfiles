# User specific binraies, push it at the top
path=("$HOME/.local/bin" $path)

# Login shell profile not shared between different platforms
source ${XDG_DATA_HOME:-"$HOME/.local/share"}/zsh/local/profile.zsh
