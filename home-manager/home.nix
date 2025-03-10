{ config, pkgs, ... }:
{
  home.username = username;
  home.homeDirectory = /home/username;

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    hello
  ];

  home.file = [
   # .bashrc, ...
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };
  programs.home-manager.enable = true;
}
