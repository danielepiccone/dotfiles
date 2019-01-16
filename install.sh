#!/bin/sh
echo "Installing dependencies..."

dependencies="shellcheck build-essential"

for dependency in $dependencies; do
  sudo apt install $dependency
done
