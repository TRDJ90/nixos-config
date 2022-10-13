{ config, pkgs, system, nur, ... }:

{
  imports = (import ./programs) ++ (import ./services); 

  xdg.enable = true;

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
  };

  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

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
    bat
    htop
    neovim
    alacritty 
    helix
    exa
    firefox
    vscode
    
    #LSP servers
    rnix-lsp
  ];
}
