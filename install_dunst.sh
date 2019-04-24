#!/bin/bash

# TODO to be reviewed from https://github.com/dunst-project/dunst
echo "Installing dunst..."

dependencies="libdbus-1-dev libx11-dev libxinerama-dev libxrandr-dev libxss-dev libglib2.0-dev libpango1.0-dev libgtk-3-dev libxdg-basedir-dev"
sudo apt install "$dependencies"

pushd /tmp/
git clone https://github.com/dunst-project/dunst.git
make
sudo make install
popd

mkdir -p ~/.config/dunst
pushd ~/.config/dunst
ln -s ~/dotfiles/dunst/dunstrc
popd

