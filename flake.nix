{
  description = "Nixos virtual machine";
  
  inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/release-22.05";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    
    home-manager = {
			url = "github:nix-community/home-manager/release-22.05";
			inputs.nixpkgs.follows = "nixpkgs";
    };    
  };
  	
  outputs = { self, nixpkgs, home-manager, ... }@inputs : let
		mkVM = import ./lib/mkvm.nix;

		overlays = [
		];		
	in {
    nixosConfigurations.vm-aarch64 = mkVM "vm-aarch64" {
      inherit nixpkgs home-manager;
      system = "aarch64-linux";
      user   = "thubie";

      overlays = overlays ++ [(final: prev: {
        # TODO: drop after release following NixOS 22.05
        open-vm-tools = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.open-vm-tools;

        # We need Mesa on aarch64 to be built with "svga". The default Mesa
        # build does not include this: https://github.com/Mesa3D/mesa/blob/49efa73ba11c4cacaed0052b984e1fb884cf7600/meson.build#L192
        mesa = prev.callPackage "${inputs.nixpkgs-unstable}/pkgs/development/libraries/mesa" {
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
    };
    nixosConfigurations.parallels-aarch64 = mkVM "parallels-aarch64" {
      inherit overlays nixpkgs home-manager;
      system = "aarch64-linux";
      user   = "thubie";
    };
	};
}
