#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
target="${ZDOTDIR:-$HOME}/.zshrc"

usage() {
  printf 'Usage: %s [--packages]\n' "$0"
  printf '  --packages  Install Zsh and available optional tools before linking\n'
}

as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    printf 'Root access is required to install apt packages (sudo was not found).\n' >&2
    return 1
  fi
}

install_packages() {
  case $(uname -s) in
    Darwin)
      if ! command -v brew >/dev/null 2>&1; then
        printf 'Homebrew is required to install packages on macOS: https://brew.sh\n' >&2
        return 1
      fi
      brew bundle --file "$repo_dir/Brewfile"
      ;;
    Linux)
      if ! command -v apt-get >/dev/null 2>&1; then
        printf 'This setup supports apt-based Linux distributions.\n' >&2
        return 1
      fi

      as_root apt-get update
      set -- zsh
      for package in zsh-autosuggestions zsh-syntax-highlighting atuin bat eza; do
        if apt-cache show "$package" >/dev/null 2>&1; then
          set -- "$@" "$package"
        else
          printf 'Skipping %s (not available from configured apt repositories)\n' "$package"
        fi
      done
      as_root apt-get install --yes "$@"
      ;;
    *)
      printf 'Unsupported operating system: %s\n' "$(uname -s)" >&2
      return 1
      ;;
  esac
}

case ${1:-} in
  '') ;;
  --packages)
    [ "$#" -eq 1 ] || { usage >&2; exit 2; }
    install_packages
    ;;
  -h|--help)
    usage
    exit 0
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

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
