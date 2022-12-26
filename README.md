# Dotfiles

## Overview

This repositry contains my dotfiles in a linux desktop. Managed by a
little script --
[make_symlink.py](https://github.com/inclyc/dotfiles/blob/master/make_symlink.py).

## Features

1. Cross platform
2. Machine-spec local configurations
3. Fast startup (no oh-my-zsh)
## Python Script

This python script will automatically look for individual files in the
dotfiles directory, then use unified management rules to determine where
they should be placed, and then create symlinks for each file.

The following table lists the mapping rules for files managed by this script.

<div align="center">

| File Type | Rule|
| :-----:   | :--:|
| zsh       | ${ZDOTDIR:-"$HOME"}/%s|
| .tmux.conf | $HOME/.config/tmux/tmux.conf |
| nvim | $XDG_CONFIG_HOME/nvim |

</div>

## Note

1. Recommended `zsh` version >= 5.9
2. Default keymaps for **VIM** users, and you can use `jk` to substitute `ESC`
