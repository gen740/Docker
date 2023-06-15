FROM archlinux:latest
LABEL version="ubuntu"

ENV USER gen740
ENV USERHOME /home/${USER}
ENV TZ=Asia/Tokyo

RUN useradd -m -G wheel ${USER} && \
    echo "${USER}:${USER}" | chpasswd && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


RUN pacman -Syu --noconfirm git wget tmux npm tzdata base-devel cmake zsh sudo ninja gtest make \
    gettext libtool automake unzip curl boost python sqlite ncurses openssl readline
RUN pacman -Sy --noconfirm iproute2 openssh


RUN mkdir -p ${USERHOME}/.local/tools

## Pyenv
RUN pacman -Sy --noconfirm base-devel openssl zlib xz tk
RUN git clone https://github.com/pyenv/pyenv.git ${USERHOME}/.pyenv && cd ${USERHOME}/.pyenv && src/configure && make -C src \
    && git clone https://github.com/pyenv/pyenv-virtualenv.git ${USERHOME}/.pyenv/plugins/pyenv-virtualenv \
    &&  git clone https://github.com/pyenv/pyenv-update.git ${USERHOME}/.pyenv/plugins/pyenv-update \
    && ${USERHOME}/.pyenv/bin/pyenv install 3.10.10 3.11.2

RUN ${USERHOME}/.pyenv/bin/pyenv virtualenv 3.10.10 neovim-3
    # && ${USERHOME}/.pyenv/versions/neovim-3/bin/python3 -m pip install pynvim

# ## Neovim
# RUN git clone https://github.com/neovim/neovim.git ${USERHOME}/.local/tools/neovim \
#     && cd ${USERHOME}/.local/tools/neovim \
#     && make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=${USERHOME}/.local install

USER ${USER}
RUN git clone https://github.com/gen740/config.nvim.git ${USERHOME}/.config/nvim
RUN git clone https://github.com/gen740/dotfiles.git ${USERHOME}/.dotfiles \
    && ${USERHOME}/.dotfiles/setup.zsh

# RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

RUN echo ${USER} | sudo -S chown -R ${USER}:${USER} ${USERHOME}
RUN echo ${USER} | sudo -S chsh -s /bin/zsh
