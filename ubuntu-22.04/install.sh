#!/bin/bash

set -ex

# Locale dependencies
apt-get -y install tzdata locales

# LLVM latest
apt-get -y install lsb-release wget software-properties-common gnupg
bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"


# Neovim dependencies
# https://github.com/neovim/neovim/blob/master/BUILD.md#ubuntu--debian
apt-get -y install ninja-build gettext cmake unzip curl

# Pyenv dependencies
# https://github.com/pyenv/pyenv/wiki
apt-get -y install build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev curl \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# Tools
apt-get -y install wget git zsh tmux fd-find ripgrep aptitude

## locale configuration
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone
sed -i '/^#.*en_US.UTF-8/s/^#//' /etc/locale.gen
locale-gen
yes | apt-get install -y sudo
