{ config, pkgs, ... }:

{
  home.username = "thubie";
  home.homeDirectory = "/home/thubie";
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
      git
      htop
      neovim
      firefox
      alacritty 
  ];	
}
