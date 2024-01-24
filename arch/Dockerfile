FROM archlinux:latest
LABEL version="archlinux"

ENV USER gen740
ENV USERHOME /home/${USER}
ENV TZ=Asia/Tokyo

RUN useradd -m -G wheel ${USER} && \
    echo "${USER}:${USER}" | chpasswd && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


RUN pacman -Syu --noconfirm git wget tmux npm tzdata base-devel cmake zsh sudo ninja gtest make \
    gettext libtool automake unzip curl boost python sqlite ncurses openssl readline clang gcc pkgconfig deno
RUN pacman -Sy --noconfirm iproute2 openssh

## Pyenv
RUN pacman -Sy --noconfirm base-devel openssl zlib xz tk

RUN mkdir -p ${USERHOME}/.local/tools \
    && git clone https://github.com/neovim/neovim ${USERHOME}/.local/tools/neovim \
    && cd ${USERHOME}/.local/tools/neovim \
    && make CMAKE_BUILD_TYPE=Release \
    && make CMAKE_INSTALL_PREFIX=${USERHOME}/.local install
    RUN pacman -Sy --noconfirm lua-language-server stylua

## Add wezterm terminfo
RUN tempfile=$(mktemp) \
    && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo \
    && tic -x -o ~/.terminfo $tempfile \
    && rm $tempfile


## Neovim
RUN git clone https://github.com/pyenv/pyenv.git ${USERHOME}/.pyenv && cd ${USERHOME}/.pyenv && src/configure && make -C src \
    && git clone https://github.com/pyenv/pyenv-virtualenv.git ${USERHOME}/.pyenv/plugins/pyenv-virtualenv \
    &&  git clone https://github.com/pyenv/pyenv-update.git ${USERHOME}/.pyenv/plugins/pyenv-update

## Others
RUN pacman -Sy --noconfirm fd lsd fzf
RUN pacman -Sy --noconfirm gcc ripgrep

USER ${USER}
RUN git clone https://github.com/gen740/config.nvim.git ${USERHOME}/.config/nvim
RUN git clone https://github.com/gen740/dotfiles.git ${USERHOME}/.dotfiles \
    && ${USERHOME}/.dotfiles/setup.zsh

## RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

RUN echo ${USER} | sudo -S chown -R ${USER}:${USER} ${USERHOME}
RUN echo ${USER} | sudo -S chsh -s /bin/zsh
