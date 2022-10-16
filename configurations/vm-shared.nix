
{ config, pkgs, lib, currentSystem, currentSystemName,... }:

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
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
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

    xserver = {
      enable = true;
      layout = "us";
      dpi = 220;

      displayManager = {
        defaultSession = "none+bspwm";
        lightdm.enable = true;

        # AARCH64: For now, on Apple Silicon, we must manually set the
        # display resolution. This is a known issue with VMware Fusion.
        sessionCommands = ''
          ${pkgs.xorg.xset}/bin/xset r rate 500 40
        '';
      };

      windowManager.bspwm = {
        enable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    font-awesome
    gnumake
    killall
    rxvt-unicode-unwrapped

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

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  #users.defaultUserShell = pkgs.fish;

  #environment.shells = with pkgs; [fish];
  environment.variables.EDITOR = "nvim";
  environment.variables.TERMINAL = "alacritty";
}

  
