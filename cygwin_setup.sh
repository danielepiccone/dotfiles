#!/bin/bash
# Link Windows Vim files
if [ -a /cygdrive/c/Users/$1 ]
then
    echo "Importing Cygwin arguments from user $1"
    ln -s /cygdrive/c/Windows/gvim.bat /usr/bin/gvim
    cd /home
    ln -s /cygdrive/c/Users/$1/ $1
fi
