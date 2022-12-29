## RUN: env ZDOTDIR=zdotdir %{dotlink} -n --verify -w .. | FileCheck %s

```
CHECK: zsh/.p10k.zsh => zdotdir/.p10k.zsh
CHECK-NEXT: zsh/.zprofile => zdotdir/.zprofile
CHECK-NEXT: zsh/.zshenv => zdotdir/.zshenv
CHECK-NEXT: zsh/.zshrc => zdotdir/.zshrc
```
