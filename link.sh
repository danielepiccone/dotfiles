#!/usr/bin/bash

read -p "Install .screenrc? (y/n) " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Linking .screenrc";
    ln -s ~/dotfiles/.screenrc ~/.screenrc
fi

read -p "Install .bashrc? (y/n) " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Linking .bashrc";
    ln -s ~/dotfiles/.bashrc ~/.bashrc
fi

read -p "Install z? (y/n) " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Linking /bin/local/z";
    ln -s ~/dotfiles/bin/z /usr/local/bin/z
fi

echo "Stay well.";
