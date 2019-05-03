architecture=linux_amd64
version=0.18.0

default:
	@echo "make install"

.PHONY: install
install:
	curl -L https://github.com/junegunn/fzf-bin/releases/download/${version}/fzf-${version}-${architecture}.tgz | tar xvz
	mv -f ./fzf ~/dotfiles/bin/fzf
	sudo ln -s ~/dotfiles/bin/fzf /usr/local/bin/fzf

