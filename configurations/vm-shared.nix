{ config, pkgs, lib, currentSystem, currentSystemName,... }:

let 

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
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  nix = {
    settings.auto-optimise-store = true;
	  gc = {
		  automatic = true;
		  dates = "weekly";
		  options = "--delete-older-than 7d";
	  };
    extraOptions = "experimental-features = nix-command flakes";
  };

  nixpkgs.config.allowUnfree =true;

  hardware = {
	  opengl = {
		  enable = true;
		  driSupport = true;
	  };
    video.hidpi.enable = true;
  };

  boot = {
    cleanTmpDir = true;
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
      timeout = 5;
      systemd-boot.consoleMode = "0";
    };
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  time.timeZone = "Europe/Amsterdam";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  
  fonts = {
    fonts = with pkgs; [
	    jetbrains-mono
	    (nerdfonts.override { fonts = ["JetBrainsMono" ]; })
    ];

    fontconfig = {
	    hinting.autohint = true;
	    defaultFonts = {
	      emoji = ["OpenMoji Color"];
	    };
    };
  };

  services = {
    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };
    
    openssh = {
      enable = true;
      passwordAuthentication = false;
      # kdbInteractiveAuthentication = false;
    };

     /* 
     xserver = {
      enable = true;
      layout = "us";
      libinput = {
        enable = true;
        mouse = {
          accelProfile = "flat";
          middleEmulation = false;
        };
      };

      displayManager = {
        defaultSession = "none+i3";
        sddm.autoNumlock = true;
      };

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
    };
    */
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    alacritty
    kitty
    gnumake
    killall
    rxvt-unicode-unwrapped
    xclip
    niv
    glxinfo

    #sway stuff
    sway
    dbus-sway-environment
    configure-gtk
    wayland
    glib # gsettings
    dracula-theme # gtk theme
    gnome.adwaita-icon-theme  # default gnome cursors
    swaylock
    swayidle
    #grim # screenshot functionality
    #slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    bemenu # wayland clone of dmenu
    mako # notification system developed by swaywm maintainer


    # For hypervisors that support auto-resizing, this script forces it.
    # I've noticed not everyone listens to the udev events so this is a hack.
    (writeShellScriptBin "xrandr-auto" ''
      xrandr --output Virtual-1 --auto
    '')
  ];

  

  services.pipewire = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  #users.defaultUserShell = pkgs.fish;

  #environment.shells = with pkgs; [fish];
  #environment.variables.EDITOR = "vim";
  #environment.variables.TERMINAL = "alacritty";
  
  system.autoUpgrade = {
	  enable = true;
	  channel = "https://nixos.org/channels/nixos-unstable";
  };

  networking.firewall.enable = false;
  system.stateVersion = "22.11"; # Did you read the comment?
}

  
