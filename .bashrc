# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Shell Options

# Don't wait for job termination notification
set -o notify

# Set vi mode
set -o vi

# Following the real structure with symbolic links
set -P

# Aliases

# Default to human readable figures
alias df='df -h'
alias du='du -h'
#
# Misc :)
alias less='less -r'                          # raw control characters
alias grep='grep --color'                     # show differences in colour
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias ls='ls --color=auto'                 # classify files in colour
alias sgrep='grep -R --include=\*{c,h} * -e ' # grep source code

if [ -e /usr/share/terminfo/x/xterm-256color -a $TERM != 'screen-256color' ]; then
    export TERM='xterm-256color'
fi

export SHELLOPTS
export PYTHONSTARTUP="$HOME/.pythonrc"
export PATH="~/scripts:$PATH"

# Don't tab-complete hidden files
bind 'set match-hidden-files off' 

if [ -e "${HOME}/.git-completion.bash" ] ; then
    source "${HOME}"/.git-completion.bash
fi 
