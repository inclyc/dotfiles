#!/usr/bin/env python3

import logging
import os
import re
from argparse import ArgumentParser
from typing import Optional

from genericpath import isdir, isfile

registry = {
    # TMUX could choose .tmux.conf and ~/.config/tmux/tmux.conf
    # ~/.config/tmux/tmux.conf is hardcoded, not XDG_CONFIG_HOME
    # See https://wiki.archlinux.org/title/tmux
    '.tmux.conf': "{}/.config/tmux/tmux.conf".format(os.environ['HOME'])
}


def find_target(s) -> Optional[str]:
    if s in registry:
        return registry[s]
    if re.match(r'(.*)bash', s) is not None \
            or s in {".zshrc", ".zprofile"}:
        # These files just need a $HOME prefix
        return "{}/{}".format(os.environ['HOME'], s)
    return None


ignore_pattern = [r'(.*)\.git']
force_generate = False


def make_link(name: str, path: str):
    _target = find_target(name)
    if _target is None:
        logging.info(f"Ignoring file: {path}, name: {name}")
        return
    target: str = _target
    logging.info(f"Linking {path} => {target}")
    path = os.path.abspath(path)

    def link(depth):
        if depth >= 3:
            logging.error(f"Failed to link target {target}")
            return

        def handle_exist():
            if force_generate:
                logging.warning(
                    f"Target path {target} already exists, delete it and relink")
                os.remove(target)
                link(depth + 1)  # Try again
            else:
                logging.warning(
                    f"Target path {target} already exists, skipped, use -f to force generate")

        if os.path.exists(target):
            handle_exist()

        if not os.path.exists(os.path.dirname(target)):
            os.makedirs(os.path.dirname(target))

        try:
            os.symlink(path, target)
        except FileExistsError:
            handle_exist()

    link(1)


def check_ignore(path : str):
    for p in ignore_pattern:
        if re.match(p, path) is not None:
            logging.info(
                f"Path {path} was ignored by pattern {p}.\n")
            return False

    return True


def walk(path: str, max_depth: int):
    # A set contains which paths we should ignore
    skip = {'.git'}

    # recursive DFS walk
    def vis_walk(path, depth):
        if depth > max_depth:
            logging.error(
                f"Walk depth limit exceeded! current path: {path}.")
            return
        skip.add(path)
        for item in os.listdir(path):
            full_path = os.path.join(path, item)
            if isfile(full_path):
                make_link(item, full_path)
            elif isdir(full_path) \
                    and full_path not in skip \
                    and check_ignore(full_path):
                vis_walk(full_path, depth + 1)

    vis_walk(path, 1)


def main():
    logging.basicConfig(level=logging.INFO)
    parser = ArgumentParser()
    parser.add_argument('-f', '--force', action='store_true', default=False)
    parser.add_argument('-w', '--walk', default=os.path.dirname(__file__))
    parser.add_argument('-d', '--depth', default=20)
    args = parser.parse_args()
    global force_generate
    force_generate = args.force
    walk(args.walk, args.depth)


if __name__ == '__main__':
    main()
