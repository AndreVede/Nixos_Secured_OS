{ config, pkgs, ... }:
{
  # your username
  home.username = "username";
  home.homeDirectory = /home/username;

  home.packages = with pkgs; [
    hello
  ];

  home.file = [
   # .bashrc, ...
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.git = {
    enable = true;
    userName = "my_git_username";
    userEmail = "my_git_username@mail.com";
    aliases = {
      fe = "fetch origin";
      pushme = "push -u origin HEAD";
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    # zsh variables
    envExtra = ''
      
    '';
  };
  
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
