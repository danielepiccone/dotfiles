DWM_PATCHES_DIR = ~/dotfiles/dwm/patches
DWM_PATCH = ~/dotfiles/dwm/patches/6.1.diff
DWM_XSESSION = ~/dotfiles/dwm/xsessions/dwm.desktop

DWM = dwm-6.1
DMENU = dmenu-4.6
SLOCK = slock-1.4

default:
	@echo "Use make clean install"

.PHONY: install
install: deps dmenu slock dwm xsession bins

clean:
	rm -rf ${DWM}*
	rm -rf ${DMENU}*
	rm -rf ${SLOCK}*

xsession:
	cd /usr/share/xsessions/ && sudo cp -u ${DWM_XSESSION} ./dwm.desktop

bins:
	sudo stow --restow --target=/usr/local/bin bin/

deps:
	sudo apt-get install git build-essential libxft-dev libx11-dev libxrandr-dev libxinerama-dev
	sudo apt-get install xfonts-terminus

dwm:
	wget http://dl.suckless.org/dwm/${DWM}.tar.gz
	tar xvf ${DWM}.tar.gz
	# Remove OpenBSD specific line from config
	cd ${DWM} && sed '21d' config.mk -i
	cd ${DWM} && make
	cd ${DWM} && patch config.h < ${DWM_PATCH}
	# Disable unicode in xsetroot, crashes on ubuntu 18.04
	# https://wiki.archlinux.org/index.php/dwm
	cd ${DWM} && patch drw.c < ${DWM_PATCHES_DIR}/disable_unicode.diff
	cd ${DWM} && sudo make install

dwm-save-patch:
	 cd ${DWM} && diff config.def.h config.h > ${DWM_PATCH} || true

dmenu:
	wget http://dl.suckless.org/tools/${DMENU}.tar.gz
	tar xvf ${DMENU}.tar.gz
	# Remove OpenBSD specific line from config
	cd ${DMENU} && sed '19d' config.mk -i
	cd ${DMENU} && make && sudo make install

slock:
	wget http://dl.suckless.org/tools/${SLOCK}.tar.gz
	tar xvf ${SLOCK}.tar.gz
	cd ${SLOCK} && make && sudo make install

