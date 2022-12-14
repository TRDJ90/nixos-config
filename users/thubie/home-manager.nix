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
    xdg.configFile."alacritty".source = ./alacritty;
    xdg.configFile."awesome".source = ./awesome;
    xdg.configFile."bspwm".source = ./bspwm;
    xdg.configFile."sxhkd".source = ./sxhkd;
    xdg.configFile."rofi".source = ./rofi;
    xdg.configFile."polybar".source = ./polybar;
    xdg.configFile."nvim".source = ./nvim;
    xdg.configFile."qtile".source = ./qtile;
    xdg.configFile."nushell".source = ./nushell;
    xdg.configFile."zellij".source = ./zellij;

    home.packages = with pkgs; [
        bat
        chromium
        firefox
        alacritty
        neovim   
        ripgrep
        fd
        tree
        rofi
        font-awesome
        vscode
        
        variety
        nitrogen
        feh
        
        glxinfo
        pciutils
        tdesktop

        # programming languages
        clang

        (rust-bin.fromRustupToolchainFile ./rust/rust-toolchain.toml)
        #(rust-bin.stable.latest.default.override {
        #    targets = [ "wasm32-unknown-unknown" ];
        #})

        wasm-pack
        wasm-bindgen-cli
        trunk

        protobuf
        protoc-gen-grpc-web
        dotnet-sdk
        nodejs
        python39
        python39Packages.psutil
            
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

    programs.chromium = {
        enable = true;
        extensions = [
            "nngceckbapebfimnlniiiahkandclblb"
            "cjpalhdlnbpafiamejdnhcphjbkeiagm"
        ];
    };

    services.picom = {
        enable = false;   
    };
        
    programs.alacritty = {
        enable = true;
    };

        
    programs.zellij = {
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
                success_symbol = "[???](bold green)";
                format = "[??????>](bold green) ";
            };
        };
    };

    programs.helix = {
        enable = true;
    };
}
