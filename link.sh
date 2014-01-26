#!/usr/bin/bash

git submodule init;
git submodule update;

echo "Copying .screenrc";
cp ~/dotfiles/.screenrc ~/.screenrc

echo "Copying VIM settings";
cp ~/dotfiles/.vimrc ~/.vimrc
cp ~/dotfiles/.bashrc ~/.bashrc

echo "Installing pathogen"
mkdir -p ~/.vim/autoload ~/.vim/bundle; 
cp -r ~/dotfiles/pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim

echo "Copying VIM bundles";
cp -r ~/dotfiles/bundle/ ~/.vim/

echo "Copying VIM colors";
cp -r ~/dotfiles/colors/ ~/.vim/


#cd /etc
#ln -s ~/dotfiles/.vimrc vimrc
#cd ~

echo "End.";
