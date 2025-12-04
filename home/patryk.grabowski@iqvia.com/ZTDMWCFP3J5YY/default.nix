{
  nhModules,
  config,
  pkgs,
  ...
}:
{
  imports = [
    "${nhModules}/common"
    "${nhModules}/darwin"
    ./packages.nix
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";

  # xdg.configFile."zellij/layouts/main.kdl".source = ./zellij-layout.kdl;
  home.file.zellij-layout.source = config.lib.file.mkOutOfStoreSymlink ./zellij-layout.kdl;
  home.file.zellij-layout.target = "./default.kdl";

  home.packages = with pkgs; [
    kubectl
  ];

  programs.k9s = {
    enable = true;

    settings = {
      ui = {
        mouse = true;
      };
    };
  };
}
