case $- in
    *i*) ;;
      *) return;;
esac

# History Configuration
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
HISTIGNORE="ls:ll:cd:pwd:clear:history"
HISTTIMEFORMAT="%F %T "
shopt -s histappend

# Shell Options
shopt -s checkwinsize
shopt -s cdspell
shopt -s dirspell
shopt -s autocd

# Environment Variables
export JAVA_HOME=/usr/lib/jvm/temurin-21-jdk-amd64

# Path Configuration
pathmunge() {
    if ! echo "$PATH" | grep -Eq "(^|:)$1($|:)" ; then
        if [ "$2" = "after" ] ; then
            PATH="$PATH:$1"
        else
            PATH="$1:$PATH"
        fi
    fi
}

pathmunge "$HOME/.local/bin"
pathmunge "$JAVA_HOME/bin"
pathmunge "/usr/local/go/bin" after

# Prompt Configuration
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Color Support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Basic Aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -ltrh'
alias c='clear'

# Navigation Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'

# System Aliases
alias df='df -h'
alias free='free -m'
alias dud='du -d 1 -h'
alias duf='du -sh *'

# Development Tool Aliases
alias nvim="$HOME/IDEs/nvim/bin/nvim"
alias idea="$HOME/IDEs/idea/idea-IU-242.23726.103/bin/idea"
alias studio="$HOME/IDEs/android-studio/bin/studio"
alias francinette="$HOME/francinette/tester.sh"
alias paco="$HOME/francinette/tester.sh"

# Git Aliases
alias g='git'
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline'

# Alert Alias
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Utility Functions
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

mkcd() {
    mkdir -p "$1" && cd "$1"
}

resrc() {
    source ~/.bashrc
    source ~/.profile
    echo "Dotfiles resourced!"
}

# Load Additional Configurations
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Bash Completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# NVM Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
