{ home, config, ... }:

{
  home.file = {
    wallpapers = {
      source = config.lib.file.mkOutOfStoreSymlink ./home-dir/wallpapers;
      target = ".config/wallpapers";
      recursive = true;
    };

    hyprland-theme = {
      source = config.lib.file.mkOutOfStoreSymlink ./home-dir/hypr/theme.conf;
      target = ".config/hypr/theme.conf";
    };

    fsh = {
      source = config.lib.file.mkOutOfStoreSymlink ./home-dir/fsh;
      target = ".config/fsh";
      recursive = true;
    };
  };
}

