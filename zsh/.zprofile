# Login shell profile not shared between different platforms
local local_profile=${XDG_DATA_HOME:-"$HOME/.local/share"}/zsh/local/profile.zsh
if [[ -f $local_profile ]]; then
    source $local_profile
fi


# User specific binraies, push it at the top
path=("$HOME/.local/bin" $path)
