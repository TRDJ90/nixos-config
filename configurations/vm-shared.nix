{ config, pkgs, lib, currentSystem, currentSystemName,... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  time.timeZone = "Europe/Amsterdam";
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

        autoLogin = {
          enable = true;
          user = user;
        };
      };

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
    };
  };

  environment.systemPackages = with pkgs; [
     vim
     git
     wget	
     fish
  ];
  nixpkgs.config.allowUnfree =true;

  users.defaultUserShell = pkgs.fish;

  environment.shells = with pkgs; [fish];
  environment.variables.EDITOR = "vim";
  environment.variables.TERMINAL = "alacritty";
  
  system.autoUpgrade = {
	  enable = true;
	  channel = "https://nixos.org/channels/nixos-unstable";
  };

  networking.firewall.enable = false;
  system.stateVersion = "22.11"; # Did you read the comment?
}

  
