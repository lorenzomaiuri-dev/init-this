#!/bin/bash
set -e

echo "Setting up zsh and shell environment..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

chsh -s $(which zsh)

cat << 'EOF' >> ~/.zshrc

# Custom Aliases
alias ll='lsd -al'
alias gs='git status'
alias gl='git log --oneline --graph --decorate'
alias dev='cd ~/dev'

# fzf config
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

EOF

echo "Dotfiles and shell configured."
