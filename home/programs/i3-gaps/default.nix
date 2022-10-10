{ pkgs, lib, ...}:

let
  modifier = "Mod4";
  workspace = {
    terminal = "terminal";
    code = "code";
    browser = "browser";
  };
in {
  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = {
	inherit modifier;
	
	bars = [ ];
 
	window = {
	  border = 0;
	  hideEdgeBorders = "both";
	};

	gaps = {
	  inner = 10;
	  outer = 4;
	};
      };
    };
  };
}
