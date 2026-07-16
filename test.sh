#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

zsh -n "$repo_dir/.zshrc"
sh -n "$repo_dir/install.sh"

# Linking is idempotent and the resulting configuration can be loaded.
home="$tmp/home"
mkdir -p "$home"
HOME="$home" "$repo_dir/install.sh"
HOME="$home" "$repo_dir/install.sh"
test "$(readlink "$home/.zshrc")" = "$repo_dir/.zshrc"
HOME="$home" zsh -dfc 'source "$HOME/.zshrc"'

# Package installation uses Homebrew on macOS and available apt packages on Linux.
stub_bin="$tmp/bin"
log="$tmp/calls"
mkdir -p "$stub_bin"

cat > "$stub_bin/uname" <<'EOF'
#!/bin/sh
printf '%s\n' "$TEST_UNAME"
EOF
cat > "$stub_bin/brew" <<'EOF'
#!/bin/sh
printf 'brew' >> "$CALL_LOG"
printf ' %s' "$@" >> "$CALL_LOG"
printf '\n' >> "$CALL_LOG"
EOF
cat > "$stub_bin/apt-get" <<'EOF'
#!/bin/sh
printf 'apt-get' >> "$CALL_LOG"
printf ' %s' "$@" >> "$CALL_LOG"
printf '\n' >> "$CALL_LOG"
EOF
cat > "$stub_bin/apt-cache" <<'EOF'
#!/bin/sh
test "$1" = show
test "$2" != atuin
EOF
cat > "$stub_bin/id" <<'EOF'
#!/bin/sh
test "$1" = -u
printf '0\n'
EOF
cat > "$stub_bin/apt" <<'EOF'
#!/bin/sh
exit 0
EOF
cat > "$stub_bin/sudo" <<'EOF'
#!/bin/sh
exec "$@"
EOF
cat > "$stub_bin/batcat" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod +x "$stub_bin"/*

TEST_UNAME=Darwin CALL_LOG="$log" PATH="$stub_bin:/usr/bin:/bin" \
  HOME="$tmp/mac-home" "$repo_dir/install.sh" --packages
grep -Fqx "brew bundle --file $repo_dir/Brewfile" "$log"

: > "$log"
TEST_UNAME=Linux CALL_LOG="$log" PATH="$stub_bin:/usr/bin:/bin" \
  HOME="$tmp/linux-home" "$repo_dir/install.sh" --packages
grep -Fqx 'apt-get update' "$log"
grep -Fqx 'apt-get install --yes zsh zsh-autosuggestions zsh-syntax-highlighting bat eza' "$log"

# Debian's batcat name, apt aliases, and plugin discovery are recognized.
plugin_share="$tmp/homebrew/share"
mkdir -p "$plugin_share/zsh-autosuggestions" "$plugin_share/zsh-syntax-highlighting"
printf 'typeset -g TEST_AUTOSUGGESTIONS=loaded\n' > \
  "$plugin_share/zsh-autosuggestions/zsh-autosuggestions.zsh"
printf 'typeset -g TEST_HIGHLIGHTING=loaded\n' > \
  "$plugin_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

zsh_bin=$(command -v zsh)
# The single-quoted assertions are evaluated by the child Zsh process.
# shellcheck disable=SC2016
PATH="$stub_bin:/usr/bin:/bin" HOME="$home" HOMEBREW_PREFIX="$tmp/homebrew" \
  "$zsh_bin" -dfc '
    set -e
    source "$HOME/.zshrc"
    [[ ${aliases[in]} == *"apt install" ]]
    [[ ${aliases[cat]} == "batcat --theme ansi -pp" ]]
    [[ $TEST_AUTOSUGGESTIONS == loaded && $TEST_HIGHLIGHTING == loaded ]]
  '
