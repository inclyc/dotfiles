#!/usr/bin/env python3

import logging
import os
from argparse import ArgumentParser
from typing import Optional, Tuple, Dict


def findtarget(root: str, name: str, isfile: bool) -> Optional[str]:
    HOME = os.getenv("HOME", "~")
    XDG_CONFIG_HOME = os.getenv("XDG_CONFIG_HOME", f"{HOME}/.config")
    ZDOTDIR = os.getenv("ZDOTDIR", HOME)
    if name.endswith('.tmux.conf'):
        # Hardcoded ~/.config/tmux, $XDG_CONFIG_HOME does not work.
        # https://wiki.archlinux.org/title/tmux
        return f"{HOME}/.config/tmux/tmux.conf"
    if name in {".zshrc", ".zprofile", ".p10k.zsh", ".zshenv"}:
        # ${ZDOTDIR:-"$HOME"}
        return f"{ZDOTDIR}/{name}"
    if root.startswith("nvim"):
        if isfile:
            return f"{XDG_CONFIG_HOME}/{root}/{name}"

    return None


def makelink(path: str, target: str, force):
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
    parser.add_argument('-n', '--dry-run', action='store_true', default=False)
    parser.add_argument("--verify", action='store_true', default=False)
    args = parser.parse_args()

    def handlepath(root: str, name: str, isfile: bool, filemapping: Dict[str, str]) -> Optional[Tuple[str, str]]:
        target = findtarget(root, name, isfile)
        if target:
            filemapping[os.path.join(root, name)] = target

    filemapping = {}

    for root, dirs, files in os.walk(args.walk, topdown=True):
        root: str

        # Remove "walk" prefix.
        root = root.removeprefix(args.walk)
        root = root.removeprefix("/")

        for name in files:
            handlepath(root, name, isfile=True, filemapping=filemapping)
        for name in dirs:
            handlepath(root, name, isfile=False, filemapping=filemapping)

    for src, tgt in sorted(filemapping.items()):
        print(f"{src} => {tgt}")
        src = os.path.abspath(os.path.join(args.walk, src))
        if not args.dry_run:
            makelink(src, tgt, args.force)

if __name__ == '__main__':
    main()
