FROM ubuntu:22.04
LABEL version="ubuntu"

ENV USER gen740
ENV USERHOME /home/${USER}
# ENV HOME ${USERHOME}
ENV TZ=Asia/Tokyo

RUN useradd -m --groups sudo ${USER} && \
    gpasswd -a ${USER} sudo && \
    echo "${USER}:${USER}" | chpasswd && \
    echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN apt-get -y update && apt-get -y upgrade


# Install Dependencies #########################################################
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone
RUN apt-get install -y git lsb-release wget tmux npm \
    tzdata software-properties-common gnupg gcc cmake zsh
RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
RUN apt-get install -y ninja-build libgtest-dev libomp-15-dev make \
    gettext libtool libtool-bin autoconf automake g++ pkg-config unzip curl doxygen \
    libboost-all-dev python3 python3-pip python3-numpy python3-matplotlib \
    build-essential autoconf libtool pkg-config libclang-15-dev
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y libsqlite3-dev libbz2-dev \
    libncurses5-dev libgdbm-dev liblzma-dev libssl-dev tcl-dev tk-dev libreadline-dev
RUN apt-get -y install iproute2 ssh
RUN apt-get -y install x11-apps
RUN yes | apt-get install -y sudo

# Python Dependencies #########################################################
RUN apt-get -y install build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# Install config files #########################################################
USER ${USER}
RUN git clone https://github.com/gen740/config.nvim.git ${USERHOME}/.config/nvim
RUN git clone https://github.com/gen740/dotfiles.git ${USERHOME}/.dotfiles \
    && ${USERHOME}/.dotfiles/setup.zsh

# Install Cargo and Rust tools #################################################
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && ${USERHOME}/.cargo/bin/rustup update \
    && ${USERHOME}/.cargo/bin/cargo install bat fd-find lsd ripgrep

# # Install go##################################################
RUN mkdir -p ${USERHOME}/.local/tools \
    && wget https://go.dev/dl/go1.19.1.linux-amd64.tar.gz -O ${USERHOME}/.local/tools/go.tar.gz \
    && echo ${USER} | sudo -S tar -C /usr/local -xzf ${USERHOME}/.local/tools/go.tar.gz

# Install fzf ##################################################
RUN export PATH=$PATH:/usr/local/go/bin && cd ${USERHOME}/.local && curl https://raw.githubusercontent.com/junegunn/fzf/master/install | zsh

# install pyenv and setup python ##################################################
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv && cd ~/.pyenv && src/configure && make -C src \
    && git clone https://github.com/pyenv/pyenv-virtualenv.git ${USERHOME}/.pyenv/plugins/pyenv-virtualenv \
    &&  git clone https://github.com/pyenv/pyenv-update.git ${USERHOME}/.pyenv/plugins/pyenv-update \
    && ${USERHOME}/.pyenv/bin/pyenv install 3.10.10 3.11.2

RUN ${USERHOME}/.pyenv/bin/pyenv virtualenv 3.10.10 neovim-3 \
    && ${USERHOME}/.pyenv/versions/neovim-3/bin/python3 -m pip install pynvim

# Install grpc #################################################################
RUN git clone --recurse-submodule https://github.com/grpc/grpc.git ${USERHOME}/.local/tools/grpc \
    && cd ${USERHOME}/.local/tools/grpc \
    && mkdir cmake/build && cd cmake/build \
    && cmake -DgRPC_INSTALL=ON \
    -DgRPC_BUILD_TESTS=OFF \
    -DCMAKE_INSTALL_PREFIX=/opt/gRPC \
    -GNinja \
    ../.. \
    && ninja && echo ${USER} | sudo -S ninja install

# Install neovim ###############################################################
RUN git clone https://github.com/neovim/neovim.git ${USERHOME}/.local/tools/neovim \
    && cd ${USERHOME}/.local/tools/neovim \
    && make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=${USERHOME}/.local install

# Install OpenBLAS #############################################################
# RUN git clone https://github.com/xianyi/OpenBLAS.git ${USERHOME}/.local/tools/OpenBLAS \
#     && cd ${USERHOME}/.local/tools/OpenBLAS \
#     && make && make install

# Install linux-brew
RUN echo ${USER} | sudo -S env "NONINTERACTIVE=1" /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN echo ${USER} | sudo -S chown -R ${USER} /home/linuxbrew/.linuxbrew \
    && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && brew install glab gh

################################################################################

RUN echo ${USER} | sudo -S chown -R ${USER}:${USER} ${USERHOME}
# RUN chown -R ${USER}:${USER} /opt/OpenBLAS
RUN echo ${USER} | sudo -S chown -R ${USER}:${USER} /opt/gRPC
RUN echo ${USER} | sudo -S chsh -s /bin/zsh
