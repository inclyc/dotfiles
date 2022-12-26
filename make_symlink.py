#!/usr/bin/env python3

import logging
import os
from argparse import ArgumentParser
from typing import Optional

def findtarget(root: str, name: str) -> Optional[str]:
    if name.endswith('.tmux.conf'):
        # Hardcoded ~/.config/tmux, $XDG_CONFIG_HOME does not work.
        # https://wiki.archlinux.org/title/tmux
        return "{}/.config/tmux/tmux.conf".format(os.getenv("HOME"))
    if name in {".zshrc", ".zprofile", ".p10k.zsh"}:
        # ${ZDOTDIR:-"$HOME"}
        return "{}/{}".format(os.getenv("ZDOTDIR", os.getenv("HOME")), name)
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

    def handlepath(root: str, name: str):
        fullpath = os.path.join(root, name)
        target = findtarget(root, name)
        if target is not None:
            makelink(target, fullpath, args.force)

    for root, dirs, files in os.walk(args.walk, topdown=True):
        for name in files:
            handlepath(root, name)
        for name in dirs:
            handlepath(root, name)

if __name__ == '__main__':
    main()
