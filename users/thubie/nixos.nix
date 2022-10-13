{ pkgs, ... }: 

{
  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thubie = {
     isNormalUser = true;
     home = "/home/thubie"
     extraGroups = [ "wheel" "docker" ];
     shell = pkgs.fish;
  };
}