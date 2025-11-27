{ home, config, ... }:

{
  home.file = {
    wallpapers = {
      source = config.lib.file.mkOutOfStoreSymlink ./home-dir/wallpapers;
      target = ".config/wallpapers";
      recursive = true;
    };

    fsh = {
      source = config.lib.file.mkOutOfStoreSymlink ./home-dir/fsh;
      target = ".config/fsh";
      recursive = true;
    };

    nvim = {
      source = config.lib.file.mkOutOfStoreSymlink ./home-dir/nvim;
      target = ".config/nvim";
      recursive = true;
    };
  };
}

