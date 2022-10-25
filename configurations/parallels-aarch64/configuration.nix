{ config, pkgs, lib, modulesPath, ... }: {
  imports = [
    # Parallels is qemu under the covers. This brings in important kernel
    # modules to get a lot of the stuff working.
    (modulesPath + "/profiles/qemu-guest.nix")
    ../vm-shared.nix
  ];

  networking.interfaces.enp0s5.useDHCP = true;

  hardware.parallels = {
    enable = true;
  };
}
