#!/usr/bin/env bash
set -eo pipefail

architecture=linux_amd64
version=0.18.0

trap "rm -f ./fzf" ERR SIGINT

curl -L https://github.com/junegunn/fzf-bin/releases/download/${version}/fzf-${version}-${architecture}.tgz | tar xvz
sudo mv -f ./fzf /usr/local/bin/fzf


