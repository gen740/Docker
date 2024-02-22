FROM ubuntu:22.04
LABEL version="ubuntu"

ENV USER gen740
ENV USERHOME /home/${USER}
ENV XDG_CONFIG_HOME ${USERHOME}/.config
ENV NODENV_ROOT ${XDG_CONFIG_HOME}/nodenv
ENV TZ=Asia/Tokyo

RUN useradd -m --groups sudo ${USER}                                            \
    && gpasswd -a ${USER} sudo                                                  \
    && echo "${USER}:${USER}" | chpasswd                                        \
    && echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY install.sh ${USERHOME}/install.sh

RUN ${USERHOME}/install.sh && rm ${USERHOME}/install.sh

USER ${USER}

# Install Cmake/Ninja ################################################################
RUN cd ${USERHOME}                                                                                                         \
    && wget -q -O cmake_install.sh https://github.com/Kitware/CMake/releases/download/v3.28.1/cmake-3.28.1-linux-x86_64.sh \
    && chmod +x cmake_install.sh                                                                                           \
    && echo ${USER} | sudo -S ./cmake_install.sh --prefix=/usr/local --skip-license                                        \
    && rm cmake_install.sh                                                                                                 \
    # Ninja
    && cd ${USERHOME}                                                                                                      \
    && wget -q https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-linux.zip                              \
    && echo ${USER} | sudo -S unzip ninja-linux.zip -d /usr/local/bin                                                      \
    && rm ninja-linux.zip

# Install Cargo and Rust tools #################################################
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && ${USERHOME}/.cargo/bin/rustup update                                 \
    && ${USERHOME}/.cargo/bin/cargo install lsd                             \
    && rm -rf ${USERHOME}/.cargo/registry                                   \
    && ${USERHOME}/.cargo/bin/rustup toolchain remove stable

# Install go ###################################################################
RUN cd ${USERHOME}                                                                  \
    && wget -q https://go.dev/dl/go1.21.6.linux-amd64.tar.gz                        \
    && echo ${USER} | sudo -S tar -C /usr/local -xzf ./go1.21.6.linux-amd64.tar.gz  \
    && rm ./go1.21.6.linux-amd64.tar.gz                                             \
    && git clone --depth 1 https://github.com/junegunn/fzf.git ${USERHOME}/.fzf     \
    && yes | ${USERHOME}/.fzf/install

# Install gh ###################################################################
RUN cd ${USERHOME}                                                                                  \
    && git clone https://github.com/cli/cli.git cli --depth 1                                       \
    && cd cli                                                                                       \
    && echo ${USER} | sudo -S PATH=$PATH:/usr/local/go/bin make install                             \
    && cd ..                                                                                        \
    && echo ${USER} | sudo -S rm -rf cli                                                            \
    # Install neovim
    && git clone https://github.com/neovim/neovim.git ${USERHOME}/neovim                            \
    && cd ${USERHOME}/neovim                                                                        \
    && echo ${USER} | sudo -S make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/usr/local install \
    && echo ${USER} | sudo -S rm -rf ${USERHOME}/neovim

# Install pyenv and setup python ###############################################
RUN curl -sSf https://rye-up.com/get | RYE_INSTALL_OPTION="--yes" bash                                \
    curl -LsSf https://astral.sh/uv/install.sh | sh                                                   \
    # Install nodenv and setup node
    && git clone https://github.com/nodenv/nodenv.git ${NODENV_ROOT} --depth 1                        \
    && git clone https://github.com/nodenv/node-build.git ${NODENV_ROOT}/plugins/node-build --depth 1 \
    && cd ${NODENV_ROOT}                                                                              \
    && src/configure                                                                                  \
    && make -C src                                                                                    \
    && ${NODENV_ROOT}/bin/nodenv install 20.9.0 && ${NODENV_ROOT}/bin/nodenv global 20.9.0

# Configure dotfiles ###########################################################
RUN git clone https://github.com/gen740/config.nvim.git ${XDG_CONFIG_HOME}/nvim --depth 1 \
    && nvim -c 'quit'                                                                     \
    && git clone https://github.com/gen740/dotfiles.git ${USERHOME}/.dotfiles --depth 1   \
    && ${USERHOME}/.dotfiles/setup.zsh                                                    \
    && echo 'export TERM=wezterm' >> ${USERHOME}/.zshrc_local                             \
    && cd ${USERHOME}/.dotfiles/zsh_tools                                                 \
    && env "CC=/usr/bin/clang-18" "CXX=/usr/bin/clang++-18" cmake -B build -S . -GNinja   \
    && echo ${USER} | sudo -S cmake --build build --target install

################################################################################
RUN echo ${USER} | sudo -S chown -R ${USER}:${USER} ${USERHOME} \
    && echo ${USER} | sudo -S chsh -s /bin/zsh
