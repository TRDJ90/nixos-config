{ config, lib, pkgs, ... }: let 

    dbus-sway-environment = pkgs.writeTextFile {
        name = "dbus-sway-environment";
        destination = "/bin/dbus-sway-environment";
        executable = true;

        text = ''
        dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
        systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
        systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
        '';
    };

    configure-gtk = pkgs.writeTextFile {
        name = "configure-gtk";
        destination = "/bin/configure-gtk";
        executable = true;
        text = let
            schema = pkgs.gsettings-desktop-schemas;
            datadir = "${schema}/share/gsettings-schemas/${schema.name}";
        in ''
            export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
            gnome_schema=org.gnome.desktop.interface
            gsettings set $gnome_schema gtk-theme 'Dracula'
            '';
    };

in
{
    xdg.enable = true;
    #should set stateVerions here
    #home.stateVersion = "22.05";
    
    # copy home
    home.file."wallpapers".source = ../../home/wallpapers; 
        
    # copy config dotfiles
    xdg.configFile."sway/config".text = builtins.readFile ./sway;   
                
    home.packages = with pkgs; [
        bat
        firefox
        alacritty
        neovim
                    
        ripgrep
        tree
        
        vscode
            
        glxinfo

        #sway stuff
        dbus-sway-environment
        configure-gtk
        glib # gsettings
        waybar

        swaybg
        dracula-theme # gtk theme
        gnome.adwaita-icon-theme  # default gnome cursors
        swaylock
        swayidle
        #grim # screenshot functionality
        #slurp # screenshot functionality
        wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
        wofi # wayland clone of dmenu
        mako # notification system developed by swaywm maintainer
        
        # programming languages    
            
        # language servers        
        rnix-lsp
    ];

    home.sessionVariables = {
        LANG = "en_US.UTF-8";
        LC_CTYPE = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
        EDITOR = "nvim";
        PAGER = "less -FirSwX";
        MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
    };

    programs.alacritty = {
        enable = true;
        settings.window = {
        decorations = "full";
        opacity = 0.85;
        padding = {
            x = 1;
            y = 1;
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
    
    #swaymsg output "*" bg ~/nixos-config/home/wallpapers/green-misty-forest.jpeg fill
    
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
    
       
    # Use sway desktop environment with Wayland display server
    wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        # Sway-specific Configuration
        
        extraConfig = builtins.readFile ./sway;
        config = {
            terminal = "alacritty";
            menu = "wofi --show run";
            # Status bar(s)
            bars = [{
                fonts.size = 15.0;
                command = "waybar"; #You can change it if you want
                position = "top";
            }];  
            #output."*" = { bg = "~/wallpapers/green-misty-forest.jpeg fill"; };
            gaps.inner = 4;
        };
        
        # End of Sway-specificc Configuration
        extraSessionCommands = ''
            export XDG_SESSION_TYPE=wayland
            export XDG_SESSION_DESKTOP=sway
            export XDG_CURRENT_DESKTOP=sway    
            export WLR_NO_HARDWARE_CURSORS=1
        '';
    };
}
