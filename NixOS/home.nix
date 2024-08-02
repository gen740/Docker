{ config, pkgs, ... }:
import ../../.dotfiles/nix-darwin/home.nix {
  config = config;
  pkgs = pkgs;
  name = "root";
  home = "/root";
}
