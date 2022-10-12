{ config, pkgs, system, nur, ... }:

{
  imports = (import ./programs) ++ (import ./services); 

  home.username = "thubie";
  home.homeDirectory = "/home/thubie";
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
   
  programs.bash = {
    enable = true;
    #initExtra = ''
    #  fish
    #'';
  };
     
  #programs.fish.enable = true;
  #programs.fish.interactiveShellInit = ''
  #  starship init fish | source
  #'';
    
  programs.git = {
	  enable = true;
	  userName = "TRDJ90";
	  userEmail = "dontmail@example.com";
  };

  home.packages = with pkgs; [
    htop
    neovim
    alacritty 
    helix
    exa
    
    #LSP servers
    rnix-lsp
  ];
}
