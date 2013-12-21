#!/usr/bin/bash

cd ~
echo "Linking .screenrc";
ln -s dotfiles/.screenrc .screenrc

#echo "Linking .vimrc";
#ln -s dotfiles/.vimrc .vimrc

echo "Copying VIM settings for Cygwin & Win32 compatibility";
cp dotfiles/.vimrc .vimrc
cp dotfiles/.bashrc .bashrc

#cd /etc
#ln -s ~/dotfiles/.vimrc vimrc
#cd ~
