#!/bin/bash
echo "Building bins..."

(cd fzf && make)

echo "Linking bins..."

ln -s ~/dotfiles/bin/fzf /usr/local/bin/fzf
ln -s ~/dotfiles/bin/z /usr/local/bin/z
ln -s ~/dotfiles/bin/git-stats /usr/local/bin/git-stats
ln -s ~/dotfiles/bin/docker-purge /usr/local/bin/docker-purge

