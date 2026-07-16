#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

zsh -n "$repo_dir/.zshrc"
sh -n "$repo_dir/install.sh"

home="$tmp/home"
mkdir -p "$home"
HOME="$home" "$repo_dir/install.sh"
HOME="$home" "$repo_dir/install.sh"
test "$(readlink "$home/.zshrc")" = "$repo_dir/.zshrc"
HOME="$home" zsh -dfc 'source "$HOME/.zshrc"'

legacy_home="$tmp/legacy-home"
mkdir -p "$legacy_home"
printf 'old config\n' > "$legacy_home/.zshrc"
HOME="$legacy_home" "$repo_dir/install.sh"
grep -Fqx 'old config' "$legacy_home"/.zshrc.backup.*
