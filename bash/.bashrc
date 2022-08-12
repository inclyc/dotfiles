#
# ~/.bashrc
#
export XIM_PROGRAM=fcitx
export XIM=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
export PATH="$PATH:$HOME/.local/bin"
export MANPATH="$MANPATH:/usr/local/texlive/2022/texmf-dist/doc/man"
export INFOPATH="$INFOPATH:/usr/local/texlive/2022/texmf-dist/doc/info"
export PATH="$PATH:/usr/local/texlive/2022/bin/x86_64-linux"
# If not running interactively, don't do anything
[[ $- != *i* ]] && return



attach_tmux() {
	if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
		tmux_session=$1
		if tmux has-session -t $tmux_session; then
			tmux attach -t $tmux_session
		else
			tmux new -s $tmux_session
		fi
	fi
}


attach_pwd() {
	if [ $PWD = $HOME]; then
		attach_tmux "home"
	fi
}


if [ "$TERM_PROGRAM" == "vscode" ]; then
	exec fish
	return
fi




if [ ! -z "${SSH_TTY}" ]; then
	# We are in ssh.
	attach_tmux ssh
	return
fi

attach_pwd
