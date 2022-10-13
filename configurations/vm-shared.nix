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

  system.autoUpgrade = {
	  enable = true;
	  channel = "https://nixos.org/channels/nixos-unstable";
  };

  system.stateVersion = "22.11"; # Did you read the comment?

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

  #Networking
  networking.useDHCP = false;
  networking.firewall.enable = false;

  

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
	    jetbrains-mono
      fira-code
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
    neovim
    git
    wget
    
    gnumake
    killall
    rxvt-unicode-unwrapped

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

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  #users.defaultUserShell = pkgs.fish;

  #environment.shells = with pkgs; [fish];
  environment.variables.EDITOR = "nvim";
  environment.variables.TERMINAL = "alacritty";
}

  
