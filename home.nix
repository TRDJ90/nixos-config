{ config, pkgs, ... }:

{
  home.username = "thubie";
  home.homeDirectory = "/home/thubie";
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
   
  programs.git = {
	enable = true;
	userName = "TRDJ90";
	userEmail = "dontmail@example.com";
  };

  home.packages = with pkgs; [
      htop
      neovim
      firefox
      alacritty 
      exa
  ];
}
