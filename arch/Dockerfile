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
RUN pacman -Syu --noconfirm iproute2 openssh zlib xz tk

## Neovim
RUN mkdir -p ${USERHOME}/.local/tools                                               \
    && git clone https://github.com/neovim/neovim ${USERHOME}/.local/tools/neovim   \
    && cd ${USERHOME}/.local/tools/neovim                                           \
    && make CMAKE_BUILD_TYPE=Release                                                \
    && make CMAKE_INSTALL_PREFIX=${USERHOME}/.local install
RUN pacman -Syu --noconfirm lua-language-server stylua

## Add wezterm terminfo
RUN tempfile=$(mktemp)                                                                                      \
    && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo   \
    && tic -x -o ~/.terminfo $tempfile                                                                      \
    && rm $tempfile

# ## Build llvm
# RUN git clone https://github.com/llvm/llvm-project.git ${USERHOME}/.local/tools/llvm-project    \
#     && cd ${USERHOME}/.local/tools/llvm-project                                                 \
#     && cmake -Bbuild -Sllvm -GNinja                                                             \
#         -DCMAKE_BUILD_TYPE=Release                                                              \
#         -DCMAKE_INSTALL_PREFIX=$HOME/.local                                                     \
#         -DLLVM_BINUTILS_INCDIR=/usr/include                                                     \
#         -DLLVM_APPEND_VC_REV=ON                                                                 \
#         -DLLVM_VERSION_SUFFIX=""                                                                \
#         -DLLVM_HOST_TRIPLE=$CHOST                                                               \
#         -DLLVM_ENABLE_RTTI=ON                                                                   \
#         -DLLVM_ENABLE_FFI=ON                                                                    \
#         -DLLVM_INCLUDE_DOCS=OFF                                                                 \
#         -DLLVM_INCLUDE_TESTS=OFF                                                                \
#         -DFFI_INCLUDE_DIR:PATH="$(pkg-config --variable=includedir libffi)"                     \
#         -DLLVM_BUILD_LLVM_DYLIB=ON                                                              \
#         -DLLVM_LINK_LLVM_DYLIB=ON                                                               \
#         -DLLVM_INSTALL_UTILS=ON                                                                 \
#         -DLLVM_BUILD_DOCS=OFF                                                                   \
#         -DLLVM_ENABLE_DOXYGEN=OFF                                                               \
#         -DLLVM_ENABLE_SPHINX=OFF                                                                \
#         -DSPHINX_OUTPUT_HTML:BOOL=OFF                                                           \
#         -DSPHINX_WARNINGS_AS_ERRORS=OFF                                                         \
#         -DPOLLY_ENABLE_GPGPU_CODEGEN=ON                                                         \
#         -DLLDB_USE_SYSTEM_SIX=1                                                                 \
#         -DLLVM_ENABLE_PROJECTS="polly;lldb;lld;compiler-rt;clang-tools-extra;clang;mlir"        \
#         -DLLVM_ENABLE_RUNTIMES="compiler-rt;libcxx;libcxxabi;libunwind;openmp"                  \
#         -DLLVM_LIT_ARGS="-sv --ignore-fail"                                                     \
#         -DLLVM_ENABLE_DUMP=ON                                                                   \
#         -Wno-dev

## Pyenv
RUN git clone https://github.com/pyenv/pyenv.git ${USERHOME}/.pyenv && cd ${USERHOME}/.pyenv && src/configure && make -C src \
    && git clone https://github.com/pyenv/pyenv-virtualenv.git ${USERHOME}/.pyenv/plugins/pyenv-virtualenv                      \
    && git clone https://github.com/pyenv/pyenv-update.git ${USERHOME}/.pyenv/plugins/pyenv-update

## Others
RUN pacman -Syu --noconfirm fd lsd fzf
RUN pacman -Syu --noconfirm gcc ripgrep
RUN pacman -Syu --noconfirm go

USER ${USER}

## yay
RUN echo ${USER} | sudo -S chown -R ${USER}:${USER} ${USERHOME}/.local
RUN git clone https://aur.archlinux.org/yay.git ${USERHOME}/.local/tools/yay && cd ${USERHOME}/.local/tools/yay && yes | makepkg -si
RUN git clone https://github.com/gen740/config.nvim.git ${USERHOME}/.config/nvim
RUN git clone https://github.com/gen740/dotfiles.git ${USERHOME}/.dotfiles \
    && ${USERHOME}/.dotfiles/setup.zsh

## RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

RUN echo ${USER} | sudo -S chown -R ${USER}:${USER} ${USERHOME}
RUN echo ${USER} | sudo -S chsh -s /bin/zsh
