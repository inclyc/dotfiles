if [[ -r "${XDG_DATA_HOME:-"$HOME/.local/share"}/zsh/local/before/rc.zsh" ]]; then
    source "${XDG_DATA_HOME:-"$HOME/.local/share"}/zsh/local/before/rc.zsh"
fi

# Check whether or not we can attach to a tmux session
# should not attach tmux session if we are in these following cases:
# 1. no tmux executable
# 2. $PS1 is undefined
# 3. nested daemon environment
#	eliminate self loops since tmux then source this file (i.e. zshrc)
# 4. vscode environment
#	vscode built-in termianl is very small, which is not suitable for this
function _tmux_check_available() {
	command -v tmux &> /dev/null \
	&& [[ -n "$PS1" ]] \
	&& [[ ! "$TERM" =~ screen ]] \
	&& [[ ! "$TERM" =~ tmux ]] \
	&& [[ -z "$TMUX" ]] \
	&& [[ "$TERM_PROGRAM" != "vscode" ]] \
	&& true || false
}

# Check if tmux session given by $1 already exists.
# If true, attach to it, otherwise create and attach to a new session
function _tmux_new_or_attach() {
	tmux_session=$1
	if command tmux has-session -t $tmux_session; then
		command tmux attach -t $tmux_session
	else
		command tmux new -s $tmux_session
	fi
}

if [[ ! -z "${SSH_TTY}" ]] && _tmux_check_available; then
	# Attach to "ssh" session if connected from Secure Shell (SSH).
	# TMUX session manager will preserve our work if ssh connection lost.
	_tmux_new_or_attach 'ssh'
elif [[ $PWD = $HOME ]] && _tmux_check_available; then
	# Attach tmux if we are in $HOME, typically Ctrl + Shift + T
	# It is not a good idea to run many windows which it's own shell process
	_tmux_new_or_attach 'home'
fi

export GPG_TTY=$(tty)


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Preserve history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt inc_append_history share_history extended_history

# Documentation about opt: https://zsh.sourceforge.io/Doc/Release/Options.html
setopt correct
setopt autocd
setopt nomatch
setopt notify
setopt nobeep

bindkey -v '^?' backward-delete-char
bindkey '^R' history-incremental-search-backward

# Enable zsh completion
autoload -U compinit promptinit
compinit
promptinit

# Enable select completions by menu
zstyle ':completion:*' menu select

# I prefer vim
bindkey -v



# Keyboard setting
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi


# Use `jk` to escape insert mode
bindkey -M viins 'jk' vi-cmd-mode


# Package manager
export ADOTDIR=${XDG_DATA_HOME:-"$HOME/.local/share"}/zsh/antigen
source ${XDG_DATA_HOME:-"$HOME/.local/share"}/zsh/antigen.zsh

# Official plugins
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-completions

antigen bundle MichaelAquilina/zsh-you-should-use
antigen bundle momo-lab/zsh-abbrev-alias

antigen theme romkatv/powerlevel10k

antigen apply

# History substring search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

alias ls='ls --color=auto'
alias ll='ls -l'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ip='ip --color=auto'

abbrev-alias vim='nvim'
abbrev-alias vi='nvim'
abbrev-alias top='htop'

#
# Functions
# (sorted alphabetically)
#

ardu() {
  # Both `ardu https://arcanist-url.com/<REVISION>`, and `ardu <REVISION>` work.
  arc diff --update "${1:t}"
}

arpa() {
  # Both `arpa https://arcanist-url.com/<REVISION>`, and `arpa <REVISION>` work.
  arc patch "${1:t}"
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [[ -r "${XDG_DATA_HOME:-"$HOME/.local/share"}/zsh/local/after/rc.zsh" ]]; then
    source "${XDG_DATA_HOME:-"$HOME/.local/share"}/zsh/local/after/rc.zsh"
fi
