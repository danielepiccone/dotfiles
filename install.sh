#!/usr/bin/env bash
set -eo pipefail

install::dotfiles(){
  echo "Linking dotfiles..."

  trap "echo Cleanup current dotfiles before linking." ERR
  stow bash
  stow vim
  stow tmux
  stow fonts
  trap - ERR
}

install::custombins(){
  echo "Linking bins..."

  for bin in ~/dotfiles/bin/*; do
    sudo ln -s $bin /usr/local/bin/$(basename $bin) || echo "Already linked."
  done
}

install::configscripts() {
  echo "Executing configuration scripts..."

  source scripts/install_fzf.sh
  source scripts/install_libinput_gestures.sh
}

install::ubuntu() {
    dependencies="\
      shellcheck \
      build-essential \
      stow \
      vim \
      tmux \
      ack \
      tig \
      xclip \
      curl \
      ansible \
    "
    echo "Installing $dependencies with apt..."
    sudo apt-get install $dependencies -y

    install::dotfiles
    install::custombins
    install::configscripts

    (cd scripts/playbooks && sudo ansible-playbook desktop_ubuntu.yml)
}

install::fedora() {
  dependencies="
    ShellCheck \
    stow \
    vim \
    ack \
    tig\
    xclip \
  "
  echo "Installing $dependencies with dnf..."
  sudo dnf install $dependencies -y

  install::dotfiles
  install::custombins
  install::configscripts

  (cd scripts/playbooks && sudo ansible-playbook desktop_fedora.yml)
}

install::darwin() {
  dependencies="\
    shellcheck \
    coreutils \
    findutils \
    gnu-tar \
    gnu-sed \
    gawk \
    gnutls \
    gnu-indent \
    gnu-getopt \
    grep \
    vim \
    stow \
    ansible \
    tig \
  "
  echo "Installing $dependencies with homebrew..."
  brew install $dependencies

  install::dotfiles
  install::custombins
  install::configscripts
}

if [[ `pwd` != ~/dotfiles ]]; then
  echo This script must be executed in ~/dotfiles. Exiting.
  exit 1
fi

if ! git config --get user.name &> /dev/null; then
  git config --global user.name "Daniele Piccone"
fi

if ! git config --get user.email &> /dev/null; then
  git config --global user.email "mail@danielepiccone.com"
fi

echo "Requesting sudo privileges..."
sudo true


echo "Detecting platform..."

if [[  $OSTYPE == "linux"* ]]; then
  if [[ -e /etc/redhat-release ]]; then
    echo "Fedora detected."
    install::fedora
  fi

  if grep "Ubuntu" /etc/lsb-release &> /dev/null; then
    echo "Ubuntu detected."
    install::ubuntu
  fi
fi

if [[ $OSTYPE == "darwin"* ]]; then
    echo "Darwin detected."
    install::darwin
fi
