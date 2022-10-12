{ config, pkgs, lib, currentSystem, currentSystemName,... }:

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

    xserver = {
      enable = true;
      layout = "us";
      #dpi = 220;

      desktopManager = {
        plasma5.enable = false;
        #wallpaper.mode = "fill";
      };

      displayManager = {
        #defaultSession = "none+i3";
        sddm.enable = true;

        sessionCommands = ''
          ${pkgs.xorg.xset}/bin/xset r rate 200 40
        '';
      };

      #windowManager.i3 = {
      #  enable = true;
        #package = pkgs.i3-gaps;
      #};
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    wget	
    gnumake
    killall
    rxvt-unicode-unwrapped
    xclip
    niv

    # For hypervisors that support auto-resizing, this script forces it.
    # I've noticed not everyone listens to the udev events so this is a hack.
    (writeShellScriptBin "xrandr-auto" ''
      xrandr --output Virtual-1 --auto
    '')

  ] ++ lib.optionals (currentSystemName == "vm-aarch64") [
    # This is needed for the vmware user tools clipboard to work.
    # You can test if you don't need this by deleting this and seeing
    # if the clipboard sill works.
    gtkmm3
  ];

  nixpkgs.config.allowUnfree =true;

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

  
