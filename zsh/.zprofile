if [[ -r "${XDG_CONFIG_HOME:-"$HOME/.config"}/zsh/before/profile.zsh" ]]; then
    source "${XDG_CONFIG_HOME:-"$HOME/.config"}/zsh/before/profile.zsh"
fi

# User specific binraies, push it at the top
path=("$HOME/.local/bin" $path)

export XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-"$HOME/.local/state"}"

export PYTHONHISTFILE="${XDG_DATA_HOME:-"$HOME/.local/share"}/.python_historty"
export GTK_RC_FILES="${XDG_CONFIG_HOME:-"$HOME/.config"}/gtk-1.0/gtkrc"
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-"$HOME/.config"}/gtk-2.0/gtkrc"
export CONDARC="${XDG_CONFIG_HOME:-"$HOME/.config"}/conda/condarc"
export GNUPGHOME="${XDG_DATA_HOME:-"$HOME/.local/share"}/gnupg"
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export npm_config_userconfig="${XDG_CONFIG_HOME:-"$HOME/.config"}/npm/config"
export npm_config_cache="${XDG_CACHE_HOME-"$HOME/.cache"}/npm"
export npm_config_prefix="${XDG_DATA_HOME:-"$HOME/.local/share"}/npm"
export CARGO_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}/cargo"
export _JAVA_OPTIONS=-Djavafx.cachedir="${XDG_CACHE_HOME-"$HOME/.cache"}/openjfx"

if [[ -r "${XDG_CONFIG_HOME:-"$HOME/.config"}/zsh/after/profile.zsh" ]]; then
    source "${XDG_CONFIG_HOME:-"$HOME/.config"}/zsh/after/profile.zsh"
fi
