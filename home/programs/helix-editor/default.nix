{ pkgs, ...}:

{
  programs.helix = {
    enable = true;
    settings = {
      theme = "gruvbox";
      
      editor = {
        line-number = "relative";
        mouse = true;
        gutters = ["diagnostics" "line-numbers"];
        true-color = true;
        auto-completion = true;
        rulers = [80 115];
      };
      
      editor.cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "block";
      };
      
      editor.lsp = {
        display-messages = true;
      };
      
      editor.whitespace.render = {
        space = "all";
        tab = "all";
        newline = "none";
      };
    };
  };
}