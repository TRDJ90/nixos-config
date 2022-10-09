{
  description = "A very basic flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
	url = "github:nix-community/home-manager";
	inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nur = {
	url = "github:nix-community/NUR";
	inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  	
  outputs = { self, nixpkgs, home-manager, nur, ... }: 
	let
		system = "aarch64-linux";

		pkgs = import nixpkgs {
			inherit system;
			config.allowUnfree = true;
		};

		lib = nixpkgs.lib;
	in {
		nixosConfigurations = {
			nixos = lib.nixosSystem {
				inherit system;
				modules = [ 
					./configurations/configuration.nix
					home-manager.nixosModules.home-manager {
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.users.thubie = {
							imports = [
								./home.nix
							];
						};
					}
				];
			};
			#vm
			#darwin
		};
	};
}
