#!/usr/bin/env bash
echo "Installing dependencies..."

if test "$(uname)" = "Darwin"; then
  dependencies="shellcheck coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt grep vim stow ansible"
  echo "Installing $dependencies with homebrew."
  brew install $dependencies
fi

if test "$(uname)" = "Linux"; then
  dependencies="shellcheck build-essential stow vim ansible feh curl ack"
  echo "Installing $dependencies with apt."
  sudo apt-get install $dependencies -y
fi

echo "Linking dotfiles..."

stow bash
stow vim
stow tmux
stow fonts

echo "Building bins..."

(cd fzf && make)

echo "Linking bins..."

sudo ln -s ~/dotfiles/bin/fzf /usr/local/bin/fzf
sudo ln -s ~/dotfiles/bin/z /usr/local/bin/z
sudo ln -s ~/dotfiles/bin/git-stats /usr/local/bin/git-stats
sudo ln -s ~/dotfiles/bin/docker-purge /usr/local/bin/docker-purge

echo "Installing applications..."

if test "$(uname)" = "Darwin"; then
  echo "Installing application is not supported on Darwin."
  exit 0
fi

if test "$(uname)" = "Linux"; then
  (cd ansible && ./provision.sh)
  exit 0
fi
