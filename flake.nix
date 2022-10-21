{
  description = "Nixos virtual machine";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
		#nixpkgs.url = "github:nixos/nixpkgs/release-22.05";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    
    leftwm-overlay = {
      url = "github:leftwm/leftwm";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
			url = "github:nix-community/home-manager/release-22.05";
			inputs.nixpkgs.follows = "nixpkgs";
    };    
  };
  	
  outputs = { self, nixpkgs, home-manager, ... }@inputs : let
		mkVM = import ./lib/mkvm.nix;

		overlays = [
      inputs.leftwm-overlay.overlay
    ];		
	in {
    nixosConfigurations.parallels-aarch64 = mkVM "parallels-aarch64" {
      inherit overlays nixpkgs home-manager;
      system = "aarch64-linux";
      user   = "thubie";
    };
	};
}
