## RUN: env HOME=HOME %{dotlink} -n --verify -w .. | FileCheck %s

Link my scripts to $PATH, `~/.local/bin` for my personal use.

```
CHECK: bin/delete-branch => HOME/.local/bin/delete-branch
CHECK: bin/pick-branch => HOME/.local/bin/pick-branch
```
