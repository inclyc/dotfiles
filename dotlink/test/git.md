## RUN: env XDG_CONFIG_HOME=xdg_config_home %{dotlink} -n --verify -w .. | FileCheck %s

```
CHECK: git/config => xdg_config_home/git/config
CHECK: git/ignore => xdg_config_home/git/ignore
```
