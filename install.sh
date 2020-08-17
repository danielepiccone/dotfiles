#!/usr/bin/env bash

echo "Installing dependencies..."

if [[  "$(uname)" = "Linux" ]]; then
  if [[ -e /etc/redhat-release ]]; then
    dependencies="ShellCheck stow vim ack tig"
    echo "Installing $dependencies with dnf..."
    sudo dnf install $dependencies -y
  else
    dependencies="shellcheck stow vim ack tig ansible"
    echo "Installing $dependencies with apt..."
    sudo apt-get install $dependencies -y
  fi
fi

if [[ "$(uname)" = "Darwin" ]]; then
  dependencies="shellcheck coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt grep vim stow ansible tig"
  echo "Installing $dependencies with homebrew..."
  brew install $dependencies
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
  echo "Installing applications is not supported on Darwin."
  exit 1
fi

if test "$(uname)" = "Linux"; then
  echo "Provisioning the workstation..."

  if [[ -e /etc/redhat-release ]]; then
    (cd ansible && sudo ansible-playbook fedora.yml)
  else
    (cd ansible && sudo ansible-playbook ubuntu.yml)
  fi
fi
