# A clean, dependency-free prompt.
autoload -Uz colors vcs_info add-zsh-hook
colors
setopt prompt_subst

# Show the current Git branch and a small working-tree status marker.
#   + staged changes    * unstaged/untracked changes
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr ' %B%F{76}+%f%b'
zstyle ':vcs_info:git:*' unstagedstr ' %B%F{214}*%f%b'
zstyle ':vcs_info:git:*' formats ' %F{242}on%f %B%F{141} %b%f%%b%c%u'
zstyle ':vcs_info:git:*' actionformats ' %F{242}on%f %B%F{141} %b%f%%b %B%F{203}(%a)%f%%b%c%u'

add-zsh-hook precmd vcs_info

# Line one: user@hostname, location, and Git context.
# Line two: green on success, red on error (# when root).
PROMPT=$'%F{242}%n@%m%f %B%F{39}%~%f%b${vcs_info_msg_0_}\n%B%(?.%F{76}.%F{196})%(!.#.❯)%f%b '
RPROMPT='%(?..%B%F{196}✘ %?%f%b  )%F{242}%D{%I:%M %p}%f'

# Package manager, Git, and command-line shortcuts.
if (( ${+commands[apt]} )); then
  if (( EUID == 0 )); then
    _package_manager='apt'
  elif (( ${+commands[sudo]} )); then
    _package_manager='sudo apt'
  else
    _package_manager='apt'
  fi
  alias in="$_package_manager install"
  alias un="$_package_manager remove"
  alias up="$_package_manager update && $_package_manager upgrade"
  unset _package_manager
elif (( ${+commands[brew]} )); then
  alias in='brew install'
  alias un='brew uninstall'
  alias up='brew update && brew upgrade'
fi
alias grep='grep --color=auto'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gf='git fetch'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gb='git branch'
alias gps='git push'
alias gpl='git pull'
if (( ${+commands[bat]} )); then
  alias cat='bat --theme ansi -pp'
elif (( ${+commands[batcat]} )); then
  alias cat='batcat --theme ansi -pp'
fi
(( ${+commands[eza]} )) && alias ls='eza -al --header --git --icons=always'

gacp() {
  git add . &&
    git commit -m "$*" &&
    git push origin HEAD
}

# Searchable shell history powered by Atuin.
(( ${+commands[atuin]} )) && eval "$(atuin init zsh)"

# Add local tools only when they are installed.
[[ -d "$HOME/.opencode/bin" ]] && export PATH="$HOME/.opencode/bin:$PATH"

# Interactive helpers from Homebrew or Debian-family packages.
_zsh_share_dirs=(/usr/share)
if (( ${+commands[brew]} )); then
  _zsh_share_dirs=("${HOMEBREW_PREFIX:-${commands[brew]:h:h}}/share" $_zsh_share_dirs)
fi

for _zsh_plugin in \
  zsh-autosuggestions/zsh-autosuggestions.zsh \
  zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
  for _zsh_share_dir in $_zsh_share_dirs; do
    [[ -r "$_zsh_share_dir/$_zsh_plugin" ]] || continue
    source "$_zsh_share_dir/$_zsh_plugin"
    break
  done
done
unset _zsh_plugin _zsh_share_dir _zsh_share_dirs

# Load machine-specific settings without modifying this tracked config.
[[ -r "${ZDOTDIR:-$HOME}/.zshrc.local" ]] && source "${ZDOTDIR:-$HOME}/.zshrc.local"
