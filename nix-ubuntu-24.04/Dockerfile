FROM ubuntu:24.04
LABEL version="ubuntu"

ENV USER=root

RUN apt-get update && apt-get install -y curl xz-utils git
RUN curl -L https://nixos.org/nix/install | sh -s -- --daemon
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

ENV PATH=/root/.nix-profile/bin:$PATH

RUN /root/.nix-profile/bin/nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
RUN /root/.nix-profile/bin/nix-channel --update
RUN nix-shell '<home-manager>' -A install

RUN git clone --depth=1 https://github.com/gen740/dotfiles.git /root/.dotfiles
RUN git clone --depth=1 https://github.com/gen740/config.nvim.git /root/.config/nvim
COPY ./home.nix /root/.config/home-manager/home.nix

RUN home-manager switch
RUN nix-shell -p stdenv --run "nvim -c 'TSInstallSync all | quit'"
RUN nix-collect-garbage -d
RUN nix store optimise -vv
