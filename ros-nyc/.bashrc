# ~/.bashrc: executed by bash(1) for non-login shells

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

###
# HSTR
# Easily view, navigate and search your command history
# with shell history suggest box for Bash and zsh.
# source: https://github.com/dvorka/hstr
###
export HH_CONFIG=hicolor # get more colors
shopt -s histappend      # append new history items to .bash_history
# export HISTCONTROL=ignorespace # leading space hides commands from history
export HISTCONTROL=ignoreboth                                     # see https://askubuntu.com/a/15929
export HISTFILESIZE=10000                                         # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}                                   # increase history size (default is 500)
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}" # mem/file sync
# if this is interactive shell, then bind hh to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hh -- \C-j"'; fi
# if this is interactive shell, then bind 'kill last command' to Ctrl-x k
if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hh -k \C-j"'; fi

###
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
###
shopt -s checkwinsize

###
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
###
# shopt -s globstar

###
# make less more friendly for non-text input files, see lesspipe(1)
###
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

###
# set variable identifying the chroot you work in (supported by pokusew-bash-powerline.sh prompt)
###
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

###
# pokusew-bash-powerline
# Powerline for Bash in pure Bash script.
###
# shellcheck disable=SC2034
# enables login@hostname in pokusew-bash-powerline prompt
POWERLINE_LOGIN=1
if [[ -f "$HOME/pokusew-bash-powerline.sh" ]]; then
	source "$HOME/pokusew-bash-powerline.sh"
fi

###
# enable color support of ls and also add handy aliases
###
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

###
# colored GCC warnings and errors
###
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

###
# some more ls aliases
###
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

###
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
###
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

###
# if there are any alias definitions in a separate file
###
if [ -f ~/.bash_aliases ]; then
	# shellcheck disable=SC1090
	source ~/.bash_aliases
fi

###
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
###
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

###
# utils
###
export EDITOR="nano"

# not needed if running on default installation of Ubuntu 20
# as its default ~/.profile already does this (but only if the directory exists)
export PATH="$HOME/bin:$PATH"

alias bre='source ~/.bashrc'
alias bed='nano ~/.bashrc'

###
# Git shortcuts
###
alias gst="git status"
# gh is GitHub CLI (https://github.com/cli/cli)
alias gho="gh repo view --web"
# see https://git-scm.com/docs/git-log
# see https://stackoverflow.com/a/1441062
alias glog2="git log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=short-local"
# see https://stackoverflow.com/a/9463536
# show "G" for a good (valid) signature,
# "B" for a bad signature,
# "U" for a good signature with unknown validity,
# "X" for a good signature that has expired,
# "Y" for a good signature made by an expired key,
# "R" for a good signature made by a revoked key,
# "E" if the signature cannot be checked (e.g. missing key) and "N" for no signature
alias glog="git log --pretty=format:'%C(auto,yellow)%h%C(auto,magenta)% G? %C(auto,blue)%ad %C(auto,green)%aN%C(auto,red)%d%C(auto,reset) %s' --date=format-local:'%Y-%m-%d %H:%M'"
alias glog-tags="glog --no-walk --all" # optionally use --tags instead of --all
gapr() {
	echo "Running after PR rebase sequence ..."
	echo "branch = '$1'"
	if [[ -z $1 ]]; then
		echo "No branch specified!"
		return 1
	fi
	git checkout master &&
		git push origin ":$1" &&
		git pull && git fetch --all --prune &&
		git branch -D "$1" &&
		echo "Finished."
}

###
# pip3 autocompletion
###
#pip3 completion --bash
#
## pip bash completion start
#_pip_completion()
#{
#    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
#                   COMP_CWORD=$COMP_CWORD \
#                   PIP_AUTO_COMPLETE=1 $1 2>/dev/null ) )
#}
#complete -o default -F _pip_completion pip3
## pip bash completion end

###
# ROS
###
export RH_PROJECTS_DIRS="$HOME/code"
export RH_ROS_INSTALL_DIRS="/opt/ros"
export RH_SRC="$HOME/rh.sh"
if [[ -f "$RH_SRC" ]]; then
	# shellcheck disable=SC1090
	source "$RH_SRC"
fi
# rh sw foxy --silent
# ROS_DOMAIN_ID: The domain ID is used to segment the network in order to avoid interference
# between different groups of computers running ROS 2 on the same local area network.
# Machines with different domain IDs will not talk, nor interfere, with each other.
# see https://docs.ros.org/en/foxy/Tutorials/Configuring-ROS2-Environment.html#the-ros-domain-id-variable
export ROS_DOMAIN_ID=18

# colcon - ROS 2 meta-build tool
# see https://colcon.readthedocs.io/en/released/user/installation.html#quick-directory-changes
# see https://docs.ros.org/en/foxy/Tutorials/Configuring-ROS2-Environment.html#add-colcon-cd-to-your-shell-startup-script
export _colcon_cd_root=/opt/ros/foxy
if [[ -f /usr/share/colcon_cd/function/colcon_cd.sh ]]; then
	source /usr/share/colcon_cd/function/colcon_cd.sh
fi
# see https://colcon.readthedocs.io/en/released/user/installation.html#enable-completion
if [[ -f /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash ]]; then
	source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
fi
# disable colcon desktop notifications by default (system-wide)
# see https://github.com/colcon/colcon-notification/issues/31
# also note:
#   /usr/lib/python3/dist-packages/colcon_core/entry_point.py:152:
#     UserWarning: The environment variable 'COLCON_EXTENSION_BLACKLIST' has been deprecated,
#     use 'COLCON_EXTENSION_BLOCKLIST' instead
export COLCON_EXTENSION_BLOCKLIST="colcon_core.event_handler.desktop_notification"

alias ros-create-package-ros2-default='ros2 pkg create --license "Apache License 2.0" --maintainer-email "pokusew@seznam.cz" --maintainer-name "Martin Endler" '

alias car-start="ros2 topic pub /eStop -1 std_msgs/msg/Bool 'data: False'"
alias car-stop="ros2 topic pub /eStop -1 std_msgs/msg/Bool 'data: True'"

export RMW_IMPLEMENTATION="rmw_fastrtps_cpp"

export AUTO_WORKSPACE="$HOME/code/f1tenth-rewrite/ws"
if [[ -d $AUTO_WORKSPACE ]]; then
	source "$AUTO_WORKSPACE/src/auto/scripts/auto.sh"
fi

sl() {

	if [[ -f install/setup_local.bash ]]; then
		source install/setup_local.bash
		return 0
	fi

	if [[ -f devel/setup_local.bash ]]; then
		source devel/setup_local.bash
		return 0
	fi

	echo "No setup_local.bash found!" 1>&2
	return 1

}
s() {

	if [[ -f install/setup.bash ]]; then
		source install/setup.bash
		return 0
	fi

	if [[ -f devel/setup.bash ]]; then
		source devel/setup.bash
		return 0
	fi

	echo "No setup.bash found!" 1>&2
	return 1

}
alias f='source /opt/ros/foxy/setup.bash'
alias g='source /opt/ros/galactic/setup.bash'
alias ws-clean='rm -rf build/ install/ log/ .env'
alias ws-clean-all='rm -rf build/ install/ log/ .env .vscode/ python.local.sh compile_commands.json'
alias ws-build='colcon build --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=1'
