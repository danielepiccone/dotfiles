#!/usr/bin/env bash
#
# Install libinput-gestures and configures it to enable three fingers scrolling
#

rm -rf libinput-gestures
git clone https://github.com/bulletmark/libinput-gestures

(cd libinput-gestures && sudo make install)

sudo tee -a /etc/libinput-gestures.conf <<EOF
# Added by dotfiles

gesture swipe up        3 dbus-send --session --type=method_call --dest=org.gnome.Shell /org/gnome/Shell org.gnome.Shell.Eval string:'Main.overview.show();'
gesture swipe down      3 dbus-send --session --type=method_call --dest=org.gnome.Shell /org/gnome/Shell org.gnome.Shell.Eval string:'Main.overview.hide();'
EOF

# to access /dev/event*
sudo gpasswd -a $USER input

libinput-gestures-setup autostart
libinput-gestures-setup start

echo "*** Reboot to apply changes to groups ***"

rm -rf libinput-gestures
trap "rm -rf libinput-gestures" exit
