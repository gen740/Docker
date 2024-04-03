#!/bin/bash

set -ex

apt-get -y update && apt-get -y upgrade

# Locale dependencies
apt-get -y install tzdata locales

# LLVM latest
apt-get -y install lsb-release wget software-properties-common gnupg
wget -q https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
./llvm.sh 18 all
rm llvm.sh

# Neovim dependencies
# https://github.com/neovim/neovim/blob/master/BUILD.md#ubuntu--debian without ninja-build
apt-get -y install gettext cmake unzip curl

# Tools
apt-get -y install wget git zsh tmux fd-find ripgrep aptitude
ln -sf /bin/fdfind /usr/local/bin/fd
apt-get -y install direnv

## locale configuration
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone
sed -i '/^#.*en_US.UTF-8/s/^#//' /etc/locale.gen
locale-gen
yes | apt-get install -y sudo

apt-get clean
apt-get autoremove -y
