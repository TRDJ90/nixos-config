{ config, lib, pkgs, ... }:

{
    xdg.enable = true;
    #should set stateVerions here
    #home.stateVersion = "22.05";
    
    # copy home
    home.file."wallpapers".source = ./wallpapers; 
    #home.file."./.config/bspwm".source = ./bspwm;
    #home.file."./.config/sxhkd".source = ./sxhkd;
    #home.file."./.config/rofi".source = ./rofi;

    # copy config dotfiles
    xdg.configFile."i3/config".text = builtins.readFile ./i3;
    xdg.configFile."picom/picom.conf".source = ./picom/picom.conf;
    xdg.configFile."awesome".source = ./awesome;
    xdg.configFile."bspwm".source = ./bspwm;
    xdg.configFile."sxhkd".source = ./sxhkd;
    xdg.configFile."rofi".source = ./rofi;
    xdg.configFile."polybar".source = ./polybar;
    xdg.configFile."nvim".source = ./nvim;
    xdg.configFile."leftwm".source = ./leftwm;
                 
    home.packages = with pkgs; [
        bat
        firefox
        alacritty
        neovim
        feh            
        ripgrep
        tree
        rofi
        bspwm
        sxhkd
        polybar
        vscode
        
        glxinfo

        # programming languages
        clang    
            
        # language servers        
        rnix-lsp
        sumneko-lua-language-server        
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
        enable = true;   
    };
    
    /*
    services.polybar = {
        enable =  true;
        #should use builtins.readdFile to read polybar config
        config = ./polybar/config.ini;          
        script = ''
            killall polybar
            polybar -c ~/.config/polybar/config main
        '';
        package = pkgs.polybar.override {
            i3GapsSupport =  true;      
        };
    };
    */
    
    programs.alacritty = {
        enable = true;
        settings.window = {
        decorations = "full";
        opacity = 0.80;
        padding = {
            x = 0;
            y = 6;
        };
        };
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
        settings = {
            theme = "gruvbox";
            
            editor = {
                line-number = "relative";
                mouse = true;
                #gutters = ["diagnostics" "line-numbers"];
                true-color = true;
                auto-completion = true;
                #rulers = [80 115];
            };
               
            editor.cursor-shape = {
                insert = "bar";
                normal = "block";
                select = "block";
            };
            
            editor.lsp = {
                display-messages = true;
            };
            
        };
    };

    # Make cursor not tiny on HiDPI screens
    home.pointerCursor = {
        name = "Vanilla-DMZ";
        package = pkgs.vanilla-dmz;
        size = 128;
        x11.enable = true;
    };
}
