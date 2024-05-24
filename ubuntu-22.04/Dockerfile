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
RUN cd ${USERHOME}                                                                                                              \
    && wget -q -O cmake_install.sh https://github.com/Kitware/CMake/releases/download/v3.28.3/cmake-3.28.3-linux-$(uname -m).sh \
    && chmod +x cmake_install.sh                                                        \
    && echo ${USER} | sudo -S ./cmake_install.sh --prefix=/usr/local --skip-license     \
    && rm cmake_install.sh                                                              \
    # Ninja
    && cd ${USERHOME}                                                                   \
    && wget -q https://github.com/ninja-build/ninja/archive/refs/tags/v1.12.1.zip       \
    && unzip v1.12.1.zip                                                                \
    && cd ninja-1.12.1                                                                  \
    && env "CC=/usr/bin/clang-19" "CXX=/usr/bin/clang++-19" cmake -B build -S .         \
    && cmake --build build -j 8                                                         \
    && echo ${USER} | sudo -S cmake --install build --prefix /usr/local                 \
    && cd .. && rm -rf ninja-1.12.1 v1.12.1.zip

# Install Cargo and Rust tools #################################################
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && ${USERHOME}/.cargo/bin/rustup update                                 \
    && ${USERHOME}/.cargo/bin/cargo install lsd tree-sitter-cli             \
    && rm -rf ${USERHOME}/.cargo/registry                                   \
    && ${USERHOME}/.cargo/bin/rustup toolchain remove stable

# Install go ###################################################################
RUN cd ${USERHOME}                                                                                                                         \
    && wget -q -O go_install.tar.gz https://go.dev/dl/go1.22.3.linux-$([ $(uname -m) = "aarch64" ] && echo arm64 || echo amd64).tar.gz  \
    && echo ${USER} | sudo -S tar -C /usr/local -xzf ./go_install.tar.gz                                                                   \
    && rm ./go_install.tar.gz                                                                                                              \
    && git clone --depth 1 https://github.com/junegunn/fzf.git ${USERHOME}/.fzf                                                            \
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
    && git checkout stable                                                                          \
    && echo ${USER} | sudo -S make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/usr/local install \
    && echo ${USER} | sudo -S rm -rf ${USERHOME}/neovim

# Install hatch ###############################################################
RUN pip3 install --user hatch

# RUN cd ${USERHOME} curl https://get.volta.sh | bash
#
RUN $HOME/.cargo/bin/cargo install starship
#     # $HOME/.volta/bin/volta install node && $HOME/.volta/bin/volta install npm

# Configure dotfiles ###########################################################
RUN git clone https://github.com/gen740/config.nvim.git ${XDG_CONFIG_HOME}/nvim --depth 1 \
    && nvim -c 'quit'                                                                     \
    && git clone https://github.com/gen740/dotfiles.git ${USERHOME}/.dotfiles --depth 1   \
    && ${USERHOME}/.dotfiles/setup.zsh                                                    \
    && echo 'export TERM=wezterm' >> ${USERHOME}/.zshrc_local

################################################################################
RUN echo ${USER} | sudo -S chown -R ${USER}:${USER} ${USERHOME} \
    && echo ${USER} | sudo -S chsh -s /bin/zsh
