SHELL := /bin/bash
dependencies=libdbus-1-dev libx11-dev libxinerama-dev libxrandr-dev libxss-dev libglib2.0-dev libpango1.0-dev libgtk-3-dev libxdg-basedir-dev

default:
	@echo "Usage: sudo make install"

install: deps dunst config
	cd dunst && sudo make install
	make clean

clean:
	rm -rf ./dunst

.PHONY: deps
deps:
	sudo apt install ${dependencies}

dunst:
	git clone https://github.com/dunst-project/dunst.git
	cd dunst && make

config:
	mkdir -p ~/.config/dunst
	cd ~/.config/dunst && ln -s ~/dotfiles/dunst/dunstrc

