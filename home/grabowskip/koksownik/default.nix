{
  nhModules,
  config,
  pkgs,
  ...
}:
{
  imports = [
    "${nhModules}/common"
    "${nhModules}/desktop"
  ];

  # stateVersion: set to the NixOS release this machine was FIRST installed with.
  # Do NOT change this on upgrades. See: https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";

  home.file.zellij-layout.source = config.lib.file.mkOutOfStoreSymlink ./zellij-layout.kdl;
  home.file.zellij-layout.target = "./default.kdl";
}
