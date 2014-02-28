#!/usr/bin/bash

echo "Downloading modules...";
git submodule init;
git submodule update;

read -p "Install .screenrc? (y/n) " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Copying .screenrc";
    cp ~/dotfiles/.screenrc ~/.screenrc
fi

read -p "Install .bashrc? (y/n) " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Copying .bashrc";
    cp ~/dotfiles/.bashrc ~/.bashrc
fi

read -p "Install .vimrc? (y/n) " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then

    echo "Copying VIM settings";
    cp ~/dotfiles/.vimrc ~/.vimrc
fi

read -p "Install VIm bundles and Pathogen? (y/n) " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then

    echo "Installing pathogen"
    mkdir -p ~/.vim/autoload ~/.vim/bundle; 
    cp -r ~/dotfiles/pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim

    echo "Copying VIM bundles";
    cp -r ~/dotfiles/bundle/ ~/.vim/

    echo "Copying VIM colors";
    cp -r ~/dotfiles/colors/ ~/.vim/
fi

echo "Stay well.";
