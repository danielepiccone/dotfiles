#!/usr/bin/bash

cd ~
echo "Linking .screenrc";
ln -s dotfiles/.screenrc .screenrc

#echo "Linking .vimrc";
#ln -s dotfiles/.vimrc .vimrc

echo "Copying VIM settings for Cygwin & Win32";
cp dotfiles/.vimrc .vimrc

#cd /etc
#ln -s ~/dotfiles/.vimrc vimrc
#cd ~
