#!/usr/bin/env python3

import logging
import os
from argparse import ArgumentParser
from typing import Optional


def findtarget(root: str, name: str, isfile: bool) -> Optional[str]:
    HOME = os.getenv("HOME", "~")
    XDG_CONFIG_HOME = os.getenv("XDG_CONFIG_HOME", f"{HOME}/.local/share")
    ZDOTDIR = os.getenv("ZDOTDIR", HOME)
    if name.endswith('.tmux.conf'):
        # Hardcoded ~/.config/tmux, $XDG_CONFIG_HOME does not work.
        # https://wiki.archlinux.org/title/tmux
        return f"{HOME}/.config/tmux/tmux.conf"
    if name in {".zshrc", ".zprofile", ".p10k.zsh"}:
        # ${ZDOTDIR:-"$HOME"}
        return f"{ZDOTDIR}/{name}"
    if root.find("nvim") != -1:
        _, _, suffix = root.partition("nvim")
        if isfile:
            return f"{XDG_CONFIG_HOME}/nvim/{suffix}/{name}"

    return None


def makelink(target: str, path: str, force):
    logging.info(f"Linking {path} => {target}")
    path = os.path.abspath(path)

    if not os.path.exists(os.path.dirname(target)):
        os.makedirs(os.path.dirname(target))

    if os.path.exists(target):
        if force:
            logging.warning(f"Path {target} already exists, delete it.")
            os.remove(target)
        else:
            logging.warning(f"Path {target} already exists, skipped.")
            logging.warning("use -f to force generate")
            return

    os.symlink(path, target)

def main():
    logging.basicConfig(level=logging.INFO)
    parser = ArgumentParser()
    parser.add_argument('-f', '--force', action='store_true', default=False)
    parser.add_argument('-w', '--walk', default='.')
    parser.add_argument('-d', '--depth', default=20)
    args = parser.parse_args()

    def handlepath(root: str, name: str, isfile: bool):
        fullpath = os.path.join(root, name)
        target = findtarget(root, name, isfile)
        if target is not None:
            makelink(target, fullpath, args.force)

    for root, dirs, files in os.walk(args.walk, topdown=True):
        for name in files:
            handlepath(root, name, isfile=True)
        for name in dirs:
            handlepath(root, name, isfile=False)

if __name__ == '__main__':
    main()
