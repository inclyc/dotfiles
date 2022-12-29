## RUN: env XDG_CONFIG_HOME=xdg_config_home %{dotlink} -n --verify -w .. | FileCheck %s


These files are nvim settings.

```
CHECK: nvim/init.lua => xdg_config_home/nvim/init.lua
CHECK-NEXT: nvim/plugin/.keep => xdg_config_home/nvim/plugin/.keep
CHECK-NEXT: nvim/ftplugin/tex.lua => xdg_config_home/nvim/ftplugin/tex.lua
CHECK-NEXT: nvim/lua/plugins.lua => xdg_config_home/nvim/lua/plugins.lua
CHECK-NEXT: zsh/.zshrc => ~/.zshrc
```
