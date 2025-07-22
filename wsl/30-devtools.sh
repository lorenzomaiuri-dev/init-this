#!/bin/bash
set -e

echo "==> Installing base Python tools..."
sudo apt update
sudo apt install -y python3 python3-pip python3-venv

# echo "==> Installing pipx and tools..."
# python3 -m pip install --user --upgrade pip pipx
# export PATH="$HOME/.local/bin:$PATH"
# python3 -m pipx ensurepath

# hash pipx || { echo "pipx not in PATH. Aborting."; exit 1; }

# pipx install poetry
# pipx install black
# pipx install ruff
# pipx install jupyterlab

echo "==> Installing Rust..."
curl https://sh.rustup.rs -sSf | sh -s -- -y
# source "$HOME/.cargo/env"
# cargo install ripgrep exa bat fd-find

echo "==> Installing Go..."
sudo apt install -y golang-go
# go install golang.org/x/tools/cmd/goimports@latest

echo "==> Installing Node.js via NVM..."
if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install --lts
nvm use --lts
nvm alias default 'lts/*'

echo "Dev tools installed."
