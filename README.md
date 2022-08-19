# Dotfiles

This repositry contains my dotfiles in a linux desktop. Managed by a
little script --
[make_symlink.py](https://github.com/inclyc/dotfiles/blob/master/make_symlink.py).

This python script will automatically look for individual files in the
dotfiles directory, then use unified management rules to determine where
they should be placed, and then create symlinks for each file.

The following table lists the mapping rules for files managed by this script.

<div align="center">

| File Type | Rule|
| :-----:   | :--:|
| zsh       | $HOME/%s|
| bash      | $HOME/%s|
| .tmux.conf | $HOME/.config/tmux/tmux.conf |

</div>
