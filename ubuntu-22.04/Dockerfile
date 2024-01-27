FROM ubuntu:22.04
LABEL version="ubuntu"

ENV USER gen740
ENV USERHOME /home/${USER}
ENV XDG_CONFIG_HOME ${USERHOME}/.config
ENV XDG_DATA_HOME ${USERHOME}/.local/share
ENV TZ=Asia/Tokyo

RUN useradd -m --groups sudo ${USER}                                            \
    && gpasswd -a ${USER} sudo                                                  \
    && echo "${USER}:${USER}" | chpasswd                                        \
    && echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN apt-get -y update                                                           \
    && apt-get -y upgrade

COPY install.sh ${USERHOME}/install.sh
RUN ${USERHOME}/install.sh                                                      \
    && rm ${USERHOME}/install.sh

USER ${USER}

RUN git clone https://github.com/gen740/config.nvim.git ${XDG_CONFIG_HOME}/nvim
RUN git clone https://github.com/gen740/dotfiles.git ${USERHOME}/.dotfiles      \
    && ${USERHOME}/.dotfiles/setup.zsh

# Install Cargo and Rust tools #################################################
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y     \
    && ${USERHOME}/.cargo/bin/rustup update                                     \
    && ${USERHOME}/.cargo/bin/cargo install lsd

# Install go##################################################
RUN wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz                          \
    && echo ${USER} | sudo -S tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz

# Install fzf ##################################################
RUN export PATH=$PATH:/usr/local/go/bin                                         \
    && cd ${USERHOME}/.local                                                    \
    && curl https://raw.githubusercontent.com/junegunn/fzf/master/install | zsh

# Install neovim ###############################################################
RUN git clone https://github.com/neovim/neovim.git ${USERHOME}/.local/tools/neovim \
    && cd ${USERHOME}/.local/tools/neovim \
    && make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=${USERHOME}/.local install

# install pyenv and setup python ##################################################
RUN git clone https://github.com/pyenv/pyenv.git ${XDG_CONFIG_HOME}/pyenv       \
    && cd ${XDG_CONFIG_HOME}/pyenv                                              \
    && src/configure                                                            \
    && make -C src

################################################################################
RUN echo ${USER} | sudo -S chown -R ${USER}:${USER} ${USERHOME}
RUN echo ${USER} | sudo -S chsh -s /bin/zsh
