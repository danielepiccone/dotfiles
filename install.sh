#!/bin/sh
echo "Installing dependencies..."

if test "$(uname)" = "Darwin"; then
  dependencies="shellcheck coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt grep"
  brew install $dependencies
  exit 0
fi

if test "$(uname)" = "Linux"; then
  dependencies="shellcheck build-essential feh"
  sudo apt-get install $dependencies
  exit 0
fi
