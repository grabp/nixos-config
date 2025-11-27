{ pkgs, ...}:
{

  catppuccin = {
    enable = true;
    accent = "peach";
    flavor = "mocha";

    # cache = {
    #   enable = true;
    # };
  };

  imports = [
    ./import-home-dir.nix
    ./modules/bundle.nix
  ];

  home = {
    username = "grabowskip";
    homeDirectory = "/home/grabowskip";
    stateVersion = "25.05";

    sessionVariables = {
      TERMINAL = "${pkgs.wezterm}/bin/wezterm";
    };

    pointerCursor = {
      gtk.enable = true;
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "catppuccin-mocha-dark-cursors";
      size = 9;
    };
  };
 
}
