#!/bin/bash

git --git-dir="$HOME"/.dotfiles --work-tree="$HOME" config --local status.showUntrackedFiles no

# Following line rm's original dotfiles, change for commented lines to keep them as backup
#git --git-dir="$HOME"/.dotfiles --work-tree="$HOME" checkout 2>&1 | grep "^\s" | awk '{print $1}' | xargs rm

 mkdir -p "$HOME"/.dotfiles-backup
 git --git-dir="$HOME"/.dotfiles --work-tree="$HOME" checkout 2>&1 | grep "^\s" | awk '{print $1}' | xargs -I{} mv {} "$HOME"/.dotfiles-backup/{}
git --git-dir="$HOME"/.dotfiles --work-tree="$HOME"
