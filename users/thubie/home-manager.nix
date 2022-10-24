{ config, lib, pkgs, ... }:

{
    #should set stateVerions here
    #home.stateVersion = "22.05";
    
    # copy home
    home.file."wallpapers".source = ./wallpapers;
    home.file."icons".source = ./icons;
    
    xdg.enable = true;

    # copy config dotfiles
    xdg.configFile."picom/picom.conf".source = ./picom/picom.conf;
    xdg.configFile."awesome".source = ./awesome;
    xdg.configFile."bspwm".source = ./bspwm;
    xdg.configFile."sxhkd".source = ./sxhkd;
    xdg.configFile."rofi".source = ./rofi;
    xdg.configFile."polybar".source = ./polybar;
    xdg.configFile."nvim".source = ./nvim;
    xdg.configFile."qtile".source = ./qtile;
    xdg.configFile."nushell".source = ./nushell;

    home.packages = with pkgs; [
        bat
        firefox
        alacritty
        neovim   
        ripgrep
        fd
        tree
        rofi
        font-awesome
        vscode
        
        glxinfo

        # programming languages
        clang
        rustc
        cargo
        protobuf
        dotnet-sdk
        nodejs
            
        # language servers        
        rnix-lsp
        rust-analyzer
        sumneko-lua-language-server
        omnisharp-roslyn
        
        # node installed language servers
        nodePackages.pyright
        nodePackages.typescript-language-server
        nodePackages.vscode-langservers-extracted
    ];

    home.sessionVariables = {
        LANG = "en_US.UTF-8";
        LC_CTYPE = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
        EDITOR = "nvim";
        PAGER = "less -FirSwX";
        MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
    };

    services.picom = {
        enable = false;   
    };
        
    programs.alacritty = {
        enable = true;
        settings.window = {
        decorations = "full";
        opacity = 0.80;
        padding = {
            x = 0;
            y = 0;
        };
        };
    };

    programs.tmux = {
        enable = true;
    };
  
    programs.bash = {
        enable = true;
        shellOptions = [];
        historyControl = [ "ignoredups" "ignorespace" ];
        initExtra = builtins.readFile ./bashrc;

        shellAliases = {
        ga = "git add";
        gc = "git commit";
        gco = "git checkout";
        gcp = "git cherry-pick";
        gdiff = "git diff";
        gl = "git prettylog";
        gp = "git push";
        gs = "git status";
        gt = "git tag";
        };
    };
    
    programs.nushell = {
        enable = true;
        #configFile = builtins.readFile ./nushell/config.nu;
        #envFile = builtins.readFile ./nushell/env.nu;
    };

    programs.fish.enable = true;
    programs.fish.interactiveShellInit = ''
    	starship init fish | source
    '';

    programs.starship = {
        enable = true;
        settings = {
            add_newline = true;
            
            username = {
                format = "[$user](bold blue) ";
                disabled = false;
                show_always = true;
            };
            
            hostname = {
                ssh_only = false;
                format = "on [$hostname](bold red) ";
                trim_at = ".local";
                disabled = true;
            };
            
            character = {
                success_symbol = "[➜](bold green)";
                format = "[└─>](bold green) ";
            };
        };
    };

    programs.helix = {
        enable = true;
    };
}
