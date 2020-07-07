#!/bin/bash
echo "Building bins..."

(cd fzf && make)

echo "Linking bins..."

sudo ln -s ~/dotfiles/bin/fzf /usr/local/bin/fzf
sudo ln -s ~/dotfiles/bin/z /usr/local/bin/z
sudo ln -s ~/dotfiles/bin/git-stats /usr/local/bin/git-stats
sudo ln -s ~/dotfiles/bin/docker-purge /usr/local/bin/docker-purge

