# Dotfiles

## Overview

This repositry contains my dotfiles in a linux desktop. Managed by a
little script --
[dotlink.py](https://github.com/inclyc/dotfiles/blob/master/dotlink/dotlink.py).

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

| File Type | Rule| Testing |
| :-----:   | :--:| :--: | 
| zsh       | ${ZDOTDIR:-"$HOME"}/%s| [zsh.md](https://github.com/inclyc/dotfiles/blob/main/dotlink/test/zsh.md) |
| .tmux.conf | $HOME/.config/tmux/tmux.conf | [tmux.md](https://github.com/inclyc/dotfiles/blob/main/dotlink/test/tmux.md) |
| nvim | $XDG_CONFIG_HOME/nvim | [nvim.md](https://github.com/inclyc/dotfiles/blob/main/dotlink/test/nvim.md) |

</div>

## Testing

Good software should have best test coverage. This repository uses LLVM "lit" testing framework, you can install it from pypi via:

```
pip install lit
```

The dotlink package could be tested by:

```
lit -vv test
```

## Note

1. Recommended `zsh` version >= 5.9
2. Default keymaps for **VIM** users, and you can use `jk` to substitute `ESC`
