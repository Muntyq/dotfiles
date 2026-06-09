#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null)'; PS1='\[\e[38;5;98m\][\[\e[38;5;215m\]\u\[\e[0m\]@\[\e[38;5;147m\]\h\[\e[38;5;98m\]] \[\e[2m\]$( [ -n "$PS1_CMD1" ] && echo "($PS1_CMD1 \e[38;5;222m\]\e[0m)" )\[\e[0m\] \n\[\e[2m\]\w\[\e[0m\]  '
#
# ls
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -lah'

# Cd
function cdd() {
	local dir="$*";
	if [[ $# -eq 0 ]]; then
		dir=${HOME};
	fi;
	builtin cd "${dir}" && ls
}
function rebuild() {
	local mode="$1";
	local host="$2";
	local dir="${HOME}/.config/nixos";
	sudo nixos-rebuild "${mode}" --flake "${dir}#${host}";
}

alias ..='cd ..'
alias ...='cd ../..'

alias mkdir='mkdir -pv'
alias grep='grep --color=auto'
alias clear='clear && fastfetch'

function pls() {
	sudo $(fc -ln -1)
}
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
# eval "$(direnv hook bash)"

fastfetch
