{ config, pkgs, ... }:
let
  user="thubie";
in
{
  imports =
    [       
       ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    cleanTmpDir = true;
    loader = {
	systemd-boot.enable = true;
	systemd-boot.editor = false;
	efi.canTouchEfiVariables = true;
	timeout = 5;
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
	
  hardware = {
	opengl = {
		enable = true;
		driSupport = true;
	};
  };
  

  services = {
    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };
  
  nixpkgs.config.allowUnfree =true;

  environment.systemPackages = with pkgs; [
     vim
     git
     wget
     wayland	
  ];
  
  environment.variables.EDITOR = "vim";
  environment.variables.TERMINAL = "alacritty";
   

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
 
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  
  system.autoUpgrade = {
	enable = true;
	channel = "https://nixos.org/channels/nixos-unstable";
  };

  nix = {
	settings.auto-optimise-store = true;
	gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 7d";
	};
        extraOptions = "experimental-features = nix-command flakes";
  };

  system.stateVersion = "22.11"; # Did you read the comment?
}

