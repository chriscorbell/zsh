
#    ▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄ ▄▄▄   ▄▄▄ ▄▄▄▄▄▄▄    ▄▄▄▄▄▄▄
#    ▀▀▀▀▀████ █████▀▀▀ ███   ███ ███▀▀███▄ ███▀▀▀▀▀
#       ▄███▀   ▀████▄  █████████ ███▄▄███▀ ███
#     ▄███▀       ▀████ ███▀▀▀███ ███▀▀██▄  ███
# ██ █████████ ███████▀ ███   ███ ███  ▀███ ▀███████

# REQUIRED: zsh-autosuggestions zsh-syntax-highlighting nano git bat eza starship atuin

# History/completion basics
autoload -Uz compinit
compinit

# Plugins
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Environment
export EDITOR=nano
export VISUAL=nano
export PAGER=less
export PATH="$PATH:$HOME/.local/bin"

# Aliases
alias grep='grep --color=auto'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gf='git fetch'
alias cat='batcat --theme ansi -pp'
alias ls='eza -al --icons=always'
alias in='apt install'
alias up='apt update && apt upgrade -y'
alias un='apt remove'

# Git add/commit/push current branch
gacp() {
  git add .
  git commit -m "$*"
  branch=$(git rev-parse --abbrev-ref HEAD) || return 1
  git push origin "$branch"
}

# Prompt / history tools
eval "$(starship init zsh)"
eval "$(atuin init zsh)"
