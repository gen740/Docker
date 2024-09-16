{ config, pkgs, ... }:
import /root/.dotfiles/nix-darwin/home.nix {
  config = config;
  pkgs = pkgs;
  name = "root";
  home = "/root";
}
