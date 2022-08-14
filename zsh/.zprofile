export XIM_PROGRAM=fcitx
export XIM=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
export MANPATH="$MANPATH:/usr/local/texlive/2022/texmf-dist/doc/man"
export INFOPATH="$INFOPATH:/usr/local/texlive/2022/texmf-dist/doc/info"

# User specific binraies, push it at the top
path=("$HOME/.local/bin" $path)
path=("$HOME/tools/arcanist/bin" $path)

# TeXLive binraries
path+="/usr/local/texlive/2022/bin/x86_64-linux"
