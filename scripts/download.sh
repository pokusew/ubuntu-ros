#!/usr/bin/env bash

set -e

version="$1"
remote="$2"

if [[ -z $version || -z $remote ]]; then
	echo "usage: $0 <version> <remote> "
	exit 1
fi

scp "$remote:.bashrc .bash_history .gitconfig .nanorc /etc/ssh/sshd_config" "$version"
scp "$remote:.ssh/config" "$version/ssh_config"
