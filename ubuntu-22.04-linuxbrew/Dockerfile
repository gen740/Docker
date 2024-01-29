FROM ubuntu:22.04
LABEL version="ubuntu"

ENV USER gen740
ENV USERHOME /home/${USER}
ENV XDG_CONFIG_HOME ${USERHOME}/.config
ENV PYENV_ROOT ${XDG_CONFIG_HOME}/pyenv
ENV NODENV_ROOT ${XDG_CONFIG_HOME}/nodenv
ENV TZ=Asia/Tokyo

RUN useradd -m --groups sudo ${USER}                                            \
    && gpasswd -a ${USER} sudo                                                  \
    && echo "${USER}:${USER}" | chpasswd                                        \
    && echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential procps curl file git zsh
RUN yes | apt-get install -y sudo

USER ${USER}

RUN echo ${USER} | sudo -S /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN echo ${USER} | sudo -S chown -R ${USER}:${USER} /home/linuxbrew/.linuxbrew \
    && echo ${USER} | sudo -S chsh -s /bin/zsh


RUN /home/linuxbrew/.linuxbrew/bin/brew install llvm cmake ninja
RUN /home/linuxbrew/.linuxbrew/bin/brew install neovim --HEAD

# Configure dotfiles ###########################################################
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"                                                                    \
    && git clone https://github.com/gen740/config.nvim.git ${XDG_CONFIG_HOME}/nvim --depth 1                                  \
    && nvim -c 'quit'                                                                                                         \
    && git clone https://github.com/gen740/dotfiles.git ${USERHOME}/.dotfiles --depth 1                                       \
    && ${USERHOME}/.dotfiles/setup.zsh                                                                                        \
    && echo 'export TERM=wezterm' >> ${USERHOME}/.zshrc_local                                                                 \
    && cd ${USERHOME}/.dotfiles/zsh_tools                                                                                     \
    && env "CXX=/home/linuxbrew/.linuxbrew/bin/clang++" cmake -B build -S . -GNinja -DCMAKE_INSTALL_PREFIX=${USERHOME}/.local \
    && env "LIBRARY_PATH=$LIBRARY_PATH:/home/linuxbrew/.linuxbrew/lib" cmake --build build --target install

RUN /home/linuxbrew/.linuxbrew/bin/brew install tmux tokei direnv fd fzf gh glab lazygit \
    wget git curl jq lsp pre-commit ripgrep go-task pyenv pyenv-virtualenv pyright       \
    nodenv clang-format lua-language-server typescript-language-server                   \
    vscode-langservers-extracted stylua

################################################################################
RUN echo ${USER} | sudo -S chown -R ${USER}:${USER} ${USERHOME} \
    && echo ${USER} | sudo -S chsh -s /bin/zsh
