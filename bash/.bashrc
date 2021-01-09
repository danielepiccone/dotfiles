#
# .bashrc
#

# set PATH so it includes user's private bin if it exists
if [[ -d "$HOME/bin" ]] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [[ -d "$HOME/.local/bin" ]] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# set the terminal capabilities (VIM, Bash)
export TERM=xterm-256color

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Custom prompt
if [[ $color_prompt == "yes" ]]; then
  export PS1='\[\e[0;33m\]\w\[\e[0m\] \[\e[35m\]$(__git_parse_branch)\[\e[0m\]$ '
else
  export PS1='\w $(__git_parse_branch)$ '
fi

# Provide a default Node env
export NODE_ENV=development

# Export the locale with the right character set
# ref. https://stackoverflow.com/questions/56716993/error-message-when-starting-vim-failed-to-set-locale-category-lc-numeric-to-en
export LC_ALL=en_US.UTF-8

# Export the default editor, used by git
export EDITOR=vi

# Initialize Z
which z > /dev/null && . `which z`

# Append current git branch in prompt (alternative to git provided __git_ps1())
function __git_parse_branch() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi
  echo $(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
}

# Perform check when changid directory
function cd() {
  builtin cd "$@"

  # Check if a project is using a .nvmrc file
  if [ -f '.nvmrc' ]
  then
    if ! command -v nvm &> /dev/null ; then
      return
    fi
    EXPECTED=$(cat .nvmrc)
    CURRENT=$(nvm current)
    if ! [[ $CURRENT =~ $EXPECTED ]]
    then
      echo This project .nvmrc uses node $EXPECTED run 'nvm use' to update
    fi
  fi
}

# OSx Specific
if [[ "$OSTTYPE" == "darwin"* ]]; then
  # Homebrew git bash completion
  if [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
    source /usr/local/etc/bash_completion.d/git-completion.bash
  fi
fi

# Source a global environment if present
if [ -f ~/global.env ]; then
  while read -r line; do
    if [ ! -z $line ]; then
      export ${line}
    fi
  done < ~/global.env
fi
