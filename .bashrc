#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
PS1='\[\e[35m\]\[\e[1m\]\u@\h\[\e[0m\]\n\[\e[35m\]\[\e[1m\]\w\[\e[0m\]\[\e[35m\] $(git branch --show-current 2>/dev/null | sed "s/.*/ (\0)/")\[\e[0m\]\$ '

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias inatree='.~/myProjects/code/dirtree/target/release/dirtree'
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
fastfetch
