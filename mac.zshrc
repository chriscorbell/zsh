
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
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Environment
export EDITOR=nano
export VISUAL=nano
export PAGER=less
export PATH="$PATH:$HOME/.local/bin:$HOME/.opencode/bin/opencode"

# Aliases
alias grep='grep --color=auto'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gf='git fetch'
alias cat='bat --theme ansi -pp'
alias ls='eza -al --icons=always'
alias in='brew install'
alias up='brew update && brew upgrade -y'
alias un='brew uninstall'

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
