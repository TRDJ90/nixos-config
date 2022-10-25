
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
	  enable = false;
	  channel = "https://nixos.org/channels/nixos-unstable";
  };

  system.stateVersion = "22.11";

  nix = {
    settings.auto-optimise-store = true;
	  gc = {
		  automatic = true;
		  dates = "weekly";
		  options = "--delete-older-than 7d";
	  };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

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
    };

    xserver = {
      enable = true;
      layout = "us";
      dpi = 220;

      displayManager = {
        defaultSession = "none+qtile";
        gdm.enable = true;

        sessionCommands = ''
          ${pkgs.xorg.xset}/bin/xset r rate 500 40
        '';
      };
        
      windowManager.qtile = {
        enable = true;
      };  
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    gnumake
    killall
    # For hypervisors that support auto-resizing, this script forces it.
    # I've noticed not everyone listens to the udev events so this is a hack.
    (writeShellScriptBin "xrandr-auto" ''
      xrandr --output Virtual-1 --auto
    '')
  ];

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;
}

  
