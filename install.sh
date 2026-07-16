#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
target="${ZDOTDIR:-$HOME}/.zshrc"

mkdir -p "$(dirname -- "$target")"

if [ -L "$target" ] && [ "$(readlink "$target")" = "$repo_dir/.zshrc" ]; then
  printf '%s is already linked\n' "$target"
  exit 0
fi

if [ -e "$target" ] || [ -L "$target" ]; then
  backup="$target.backup.$(date +%Y%m%d%H%M%S)"
  mv "$target" "$backup"
  printf 'Backed up existing config to %s\n' "$backup"
fi

ln -s "$repo_dir/.zshrc" "$target"
printf 'Linked %s -> %s\n' "$target" "$repo_dir/.zshrc"
