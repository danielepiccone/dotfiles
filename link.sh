#!/usr/bin/bash

cd ~
ln -s dotfiles/.screenrc .screenrc
#ln -s dotfiles/.vimrc .vimrc
cd /etc
ln -s ~/dotfiles/.vimrc vimrc
cd ~
