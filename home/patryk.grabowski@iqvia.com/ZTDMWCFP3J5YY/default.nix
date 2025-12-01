{
  nhModules,
  config,
  home,
  ...
}:
{
  imports = [
    "${nhModules}/common"
    ./packages.nix
  ];

  # Enable home-manager
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";

  # xdg.configFile."zellij/layouts/main.kdl".source = ./zellij-layout.kdl;
  home.file.zellij-layout.source = config.lib.file.mkOutOfStoreSymlink ./zellij-layout.kdl;
  home.file.zellij-layout.target = "./default.kdl";
}
