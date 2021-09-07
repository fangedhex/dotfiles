# Dotfiles

Keeping my config of what I test on Linux (WM, etc...)

You can apply it by running that one command:
```bash
ansible-playbook dotfiles.yml --ask-become-pass
```
or
```bash
ansible-pull -U https://github.com/fangedhex/dotfiles dotfiles.yml --ask-become-pass
```

The master branch is using ansible as the dotfiles manager.

There is also my old branch using stow as "dotfiles manager" here : https://github.com/fangedhex/dotfiles/tree/stow_based
