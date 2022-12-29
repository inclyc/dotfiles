## RUN: env XDG_CONFIG_HOME=xdg_config_home %{dotlink} -n --verify -w .. | FileCheck %s

TMUX hardcoded ~/.config, so we must ignore XDG_CONFIG_HOME
```
CHECK: tmux/.tmux.conf => ~/.config/tmux/tmux.conf
```
