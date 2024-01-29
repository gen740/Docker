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
RUN /home/linuxbrew/.linuxbrew/bin/brew install llvm


################################################################################
RUN echo ${USER} | sudo -S chown -R ${USER}:${USER} ${USERHOME} \
    && echo ${USER} | sudo -S chsh -s /bin/zsh
