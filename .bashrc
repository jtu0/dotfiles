# If not running interactively, don't do anything
[ -z "$PS1" ] && return

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

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    xterm-*color) color_prompt=yes;;
esac

# prompt colors
GREENBOLD="\[\033[01;32m\]"
CYANBOLD="\[\033[01;36m\]"
NO_COLOUR="\[\033[0;00m\]"
BLUEBOLD="\[\033[01;34m\]"

# set regular prompt
PS1="$CYANBOLD\$(__git_committer):$GREENBOLD\$(__git_branch)$BLUEBOLD\w$NO_COLOUR\$ "

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions.
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

function __git_branch {
    local branch=`git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`

    if [[ -n $branch ]]
    then
      echo "[$branch]:"
    else
      echo ""
    fi
}

function __git_committer {
    local committer=`git config user.pair`

    if [[ -z $committer ]]
    then
      echo "$USER"
    elif [[ -n $committer ]]
    then
      echo "$committer"
    fi
}


alias pair='echo "Committing as: `git config user.name` <`git config user.email`>"'
alias unpair="git config --remove-section user 2> /dev/null; echo Unpaired.; pair"
alias unmob='unpair'

function __git_user_email {
   local current_user_email=`git config user.email`
   if [[ -n $1 ]]; then
       echo "${current_user_email//@/+$1@}"
   fi
}

# Add a colleague to the mob. unmob to return to solo committer default.
alias mob-name='git config user.pair "$(__git_committer)+INITIALS" && git config user.name "$(git config user.name) and FULL NAME" && git config user.email "$(__git_user_email "SHARED_DOMAIN_EMAIL")"; pair'

