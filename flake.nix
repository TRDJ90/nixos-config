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
		neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };
  	
  outputs = { self, nixpkgs, home-manager, ... }@inputs : let

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
		nixosConfigurations.parallels-aarch64 = mkVM "parallels-aarch64" {
      inherit overlays nixpkgs home-manager;
      system = "aarch64-linux";
      user   = "thubie";
    };
	};
}
