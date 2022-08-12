#!/usr/bin/env python

from argparse import ArgumentParser
from asyncio.log import logger
from genericpath import isdir, isfile
from typing import Optional
import logging
import os
import re

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
            or re.match(r'(.*)zsh', s) is not None:
        # These files just need a $HOME prefix
        return "{}/{}".format(os.environ['HOME'], s)
    return None


ignore_pattern = [r'(.*)\.git']
force_generate = False


def make_link(name: str, path: str):
    _target = find_target(name)
    if _target is None:
        logging.info('Ignoring file: {}, name: {}'.format(path, name))
        return
    target: str = _target
    logging.info("Linking {} => {}".format(path, target))
    path = os.path.abspath(path)

    def link(depth):
        if depth >= 3:
            logging.error("Failed to link target {}".format(target))
            return

        def handle_exist():
            if force_generate:
                logging.warning(
                    "Target path {} already exists, delete it and relink")
                os.remove(target)
                link(depth + 1)  # Try again
            else:
                logging.warning(
                    "Target path {} already exists, skipped, use -f to force generate".format(target))

        if os.path.exists(target):
            handle_exist()

        if not os.path.exists(os.path.dirname(target)):
            os.makedirs(os.path.dirname(target))

        try:
            os.symlink(path, target)
        except FileExistsError:
            handle_exist()

    link(1)


def check_ignore(path):
    for p in ignore_pattern:
        if re.match(p, path) is not None:
            logger.info(
                "Path {} was ignored by pattern {}.\n".format(path, p))
            return False

    return True


def walk(path, max_depth):
    # A set contains which paths we should ignore
    skip = {'.git'}

    # recursive DFS walk
    def vis_walk(path, depth):
        if depth > max_depth:
            logging.error(
                "Walk depth limit exceeded! current path: {}".format(path))
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
