#!/usr/bin/bash

cd ~
echo "Linking .screenrc";
ln -s dotfiles/.screenrc .screenrc
echo "Linking .vimrc";
ln -s dotfiles/.vimrc .vimrc

cd /etc
ln -s ~/dotfiles/.vimrc vimrc
cd ~
