#!/bin/bash
set -e

echo "Updating and installing base packages..."

sudo apt update && sudo apt upgrade -y

sudo apt install -y \
    build-essential \
    curl \
    wget \
    git \
    unzip \
    zip \
    software-properties-common \
    ca-certificates \
    gnupg \
    lsb-release \
    zsh \
    htop \
    neofetch \
    tree \
    lsd \
    fzf

echo "Base setup complete."
