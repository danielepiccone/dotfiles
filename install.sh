#!/bin/sh
echo "Installing dependencies..."

dependencies="shellcheck build-essential feh"

for dependency in $dependencies; do
  sudo apt install $dependency
done
