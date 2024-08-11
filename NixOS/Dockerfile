FROM nixos/nix

WORKDIR /root

RUN nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
RUN nix-channel --update

RUN nix-env --uninstall man-db
RUN nix-env --upgrade
RUN nix-shell '<home-manager>' -A install
RUN git clone https://github.com/gen740/dotfiles /root/.dotfiles
RUN git clone https://github.com/gen740/config.nvim /root/.config/nvim

COPY ./home.nix /root/.config/home-manager/home.nix

RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf
RUN nix-env --uninstall git
RUN home-manager switch
RUN nvim -c 'quit'

CMD [ "tmux" ]
