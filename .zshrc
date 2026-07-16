# A clean, dependency-free prompt.
autoload -Uz colors vcs_info add-zsh-hook
zmodload zsh/datetime
colors
setopt prompt_subst

# Show the current Git branch and a small working-tree status marker.
#   + staged changes    * unstaged/untracked changes
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr ' %B%F{76}+%f%b'
zstyle ':vcs_info:git:*' unstagedstr ' %B%F{214}*%f%b'
zstyle ':vcs_info:git:*' formats ' %F{242}on%f %B%F{141} %b%f%%b%c%u'
zstyle ':vcs_info:git:*' actionformats ' %F{242}on%f %B%F{141} %b%f%%b %B%F{203}(%a)%f%%b%c%u'

_prompt_preexec() { _prompt_cmd_start=$EPOCHREALTIME }

_prompt_precmd() {
  vcs_info

  # Show how long the last command took, but only when it's worth mentioning.
  _prompt_duration=''
  if [[ -n $_prompt_cmd_start ]]; then
    local -F elapsed=$(( EPOCHREALTIME - _prompt_cmd_start ))
    unset _prompt_cmd_start
    if (( elapsed >= 2 )); then
      local -i s=$elapsed
      local pretty
      if   (( s >= 3600 )); then pretty="$(( s / 3600 ))h $(( s % 3600 / 60 ))m"
      elif (( s >= 60   )); then pretty="$(( s / 60 ))m $(( s % 60 ))s"
      elif (( s >= 10   )); then pretty="${s}s"
      else                       pretty="$(printf '%.1fs' $elapsed)"
      fi
      _prompt_duration=" %F{242}took%f %B%F{214}${pretty}%f%b"
    fi
  fi

  # Blank line between prompts for breathing room (skip the very first one).
  [[ -n $_prompt_ran_once ]] && print ''
  _prompt_ran_once=1
}

add-zsh-hook preexec _prompt_preexec
add-zsh-hook precmd _prompt_precmd

_prompt_host='%F{242}%n@%m%f '

# Line one: user@hostname, location, Git context, and duration of slow commands.
# Line two: green on success, red on error (# when root).
PROMPT=$'${_prompt_host}%B%F{39}%~%f%b${vcs_info_msg_0_}${_prompt_duration}\n%B%(?.%F{76}.%F{196})%(!.#.❯)%f%b '
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
alias gcm='git commit -m'
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

# Interactive command-line helpers from Homebrew or Debian-family packages.
_zsh_share_dirs=(/usr/share)
if [[ -n ${HOMEBREW_PREFIX:-} ]]; then
  _zsh_share_dirs=("$HOMEBREW_PREFIX/share" $_zsh_share_dirs)
elif (( ${+commands[brew]} )); then
  _zsh_share_dirs=("${commands[brew]:h:h}/share" $_zsh_share_dirs)
fi

for _zsh_share_dir in $_zsh_share_dirs; do
  if [[ -r "$_zsh_share_dir/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$_zsh_share_dir/zsh-autosuggestions/zsh-autosuggestions.zsh"
    break
  fi
done

# Keep syntax highlighting last so it can wrap every command-line widget.
for _zsh_share_dir in $_zsh_share_dirs; do
  if [[ -r "$_zsh_share_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$_zsh_share_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    break
  fi
done
unset _zsh_share_dir _zsh_share_dirs
