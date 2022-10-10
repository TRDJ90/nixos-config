{ pkgs, ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      
      username = {
        format = "[$user](bold blue) ";
        disabled = false;
        show_always = true;
      };
      
      hostname = {
        ssh_only = false;
        format = "on [$hostname](bold red) ";
        trim_at = ".local";
        disabled = true;
      };
      
      character = {
        success_symbol = "[➜](bold green)";
        format = "[└─>](bold green) ";
      };
    };
  };
}
