{
  description = "A very basic flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
		#nixpkgs.url = "github:nixos/nixpkgs/release-22.05";
		#nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    
    home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
    };
    
		/*
    nur = {
			url = "github:nix-community/NUR";
			inputs.nixpkgs.follows = "nixpkgs";
    };
		*/

		hyprland = {
			url = "github:hyprwm/Hyprland";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };
  	
  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs : let

		#lib = nixpkgs.lib;
		mkVM = import ./lib/mkvm.nix;

		#pkgs = import nixpkgs {
		#	inherit system;
	  #	config.allowUnfree = true;
		#};

		overlays = [
			inputs.neovim-nightly-overlay.overlay
		];		
	in {
		nixosConfigurations.vmware-aarch64 = mkVM "vmware-aarch64" {
			inherit nixpkgs home-manager, hyprland;
			system = "aarch64-linux";
			user = "thubie";

			overlays = overlays ++ [(final: prev: {
				# TODO: drop after release following NixOS 22.05
        open-vm-tools = inputs.nixpkgs.legacyPackages.${prev.system}.open-vm-tools;

        # We need Mesa on aarch64 to be built with "svga". The default Mesa
        # build does not include this: https://github.com/Mesa3D/mesa/blob/49efa73ba11c4cacaed0052b984e1fb884cf7600/meson.build#L192
        mesa = prev.callPackage "${inputs.nixpkgs}/pkgs/development/libraries/mesa" {
          llvmPackages = final.llvmPackages_latest;
          inherit (final.darwin.apple_sdk.frameworks) OpenGL;
          inherit (final.darwin.apple_sdk.libs) Xplugin;

          galliumDrivers = [
            # From meson.build
            "v3d" "vc4" "freedreno" "etnaviv" "nouveau"
            "tegra" "virgl" "lima" "panfrost" "swrast"

            # We add this so we get the vmwgfx module
            "svga"
          ];
        };
			})];

			/*
			modules = [
				# hyprland.nixosModules.default
				# { programs.hyprland.enable = true; }
				./configurations/configuration.nix
				home-manager.nixosModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.users.thubie = {
						imports = [ ./home/home.nix ];
					};
				}
			];
			*/
		};
		nixosConfigurations.darwin = mkVM "macbook" rec {
			inherit nixpkgs home-manager;
			system = "aarch64-linux";
			user = "";
		};
	};
}
