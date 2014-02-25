#!/usr/bin/bash
echo "Downloading bundles and installing..."

git submodule init
git submodule update

cp bundle/ ~/.vim/bundle
