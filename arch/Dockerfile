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

## set locale
RUN sed -i '/^#.*en_US.UTF-8/s/^#//' /etc/locale.gen

## Neovim
RUN mkdir -p ${USERHOME}/.local/tools                                                          \
    && git clone https://github.com/neovim/neovim ${USERHOME}/.local/tools/neovim --depth 1 -q \
    && cd ${USERHOME}/.local/tools/neovim                                                      \
    && make CMAKE_BUILD_TYPE=Release                                                           \
    && make CMAKE_INSTALL_PREFIX=${USERHOME}/.local install
RUN pacman -Syu --noconfirm lua-language-server stylua

## Add wezterm terminfo
RUN tempfile=$(mktemp)                                                                                      \
    && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo   \
    && tic -x -o ~/.terminfo $tempfile                                                                      \
    && rm $tempfile
RUN echo "export TERM=wezterm" >> ${USERHOME}/.zshrc_local

## Build llvm
RUN git clone https://github.com/llvm/llvm-project.git ${USERHOME}/.local/tools/llvm-project --depth 1 -q   \
    && cd ${USERHOME}/.local/tools/llvm-project                                                             \
    && cmake -Bbuild -Sllvm -GNinja                                                                         \
    -DCMAKE_BUILD_TYPE=Release                                                                              \
    -DCMAKE_INSTALL_PREFIX=$HOME/.local                                                                     \
    -DLLVM_BINUTILS_INCDIR=/usr/include                                                                     \
    -DLLVM_APPEND_VC_REV=ON                                                                                 \
    -DLLVM_VERSION_SUFFIX=""                                                                                \
    -DLLVM_ENABLE_RTTI=ON                                                                                   \
    -DLLVM_ENABLE_FFI=ON                                                                                    \
    -DLLVM_INCLUDE_DOCS=OFF                                                                                 \
    -DLLVM_INCLUDE_TESTS=OFF                                                                                \
    -DFFI_INCLUDE_DIR:PATH="$(pkg-config --variable=includedir libffi)"                                     \
    -DLLVM_BUILD_LLVM_DYLIB=ON                                                                              \
    -DLLVM_LINK_LLVM_DYLIB=ON                                                                               \
    -DLLVM_INSTALL_UTILS=ON                                                                                 \
    -DLLVM_BUILD_DOCS=OFF                                                                                   \
    -DLLVM_ENABLE_DOXYGEN=OFF                                                                               \
    -DLLVM_ENABLE_SPHINX=OFF                                                                                \
    -DSPHINX_OUTPUT_HTML:BOOL=OFF                                                                           \
    -DSPHINX_WARNINGS_AS_ERRORS=OFF                                                                         \
    -DPOLLY_ENABLE_GPGPU_CODEGEN=ON                                                                         \
    -DLLDB_USE_SYSTEM_SIX=1                                                                                 \
    -DLLVM_ENABLE_PROJECTS="polly;lldb;lld;compiler-rt;clang-tools-extra;clang"                             \
    -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind;openmp"                                              \
    -DLLVM_LIT_ARGS="-sv --ignore-fail"                                                                     \
    -DLLVM_ENABLE_DUMP=ON                                                                                   \
    -DCMAKE_C_FLAGS="-w"                                                                                    \
    -DCMAKE_CXX_FLAGS="-w"                                                                                  \
    > /dev/null                                                                                            \
    && cmake --build build --target install
RUN echo 'export LD_LIBRARY_PATH=$HOME/.local/lib/x86_64-unknown-linux-gnu:$LD_LIBRARY_PATH' >> ${USERHOME}/.zshrc_local

## Pyenv
RUN git clone https://github.com/pyenv/pyenv.git ${USERHOME}/.config/pyenv -q                                        \
    && cd ${USERHOME}/.config/pyenv && src/configure && make -C src                                                  \
    && git clone https://github.com/pyenv/pyenv-virtualenv.git ${USERHOME}/.config/pyenv/plugins/pyenv-virtualenv -q \
    && git clone https://github.com/pyenv/pyenv-update.git ${USERHOME}/.config/pyenv/plugins/pyenv-update -q
RUN pyenv install 3.12.1 && pyenv virtualenv 3.12.1 main && pyenv global main

## Others
RUN pacman -Syu --noconfirm fd lsd fzf ripgrep go

USER ${USER}

RUN echo ${USER} | sudo -S chown -R ${USER}:${USER} ${USERHOME}/.local
RUN git clone https://github.com/gen740/config.nvim.git ${USERHOME}/.config/nvim -q
RUN git clone https://github.com/gen740/dotfiles.git ${USERHOME}/.dotfiles -q \
    && ${USERHOME}/.dotfiles/setup.zsh
RUN env "CC=${USERHOME}/.local/bin/clang" "CXX=${USERHOME}/.local/bin/clang++" cmake -B build -S . -GNinja -DCMAKE_INSTALL_PREFIX=${USERHOME}/.local \
    && cmake --build build --target install

RUN echo ${USER} | sudo -S chown -R ${USER}:${USER} ${USERHOME}
RUN echo ${USER} | sudo -S chsh -s /bin/zsh
