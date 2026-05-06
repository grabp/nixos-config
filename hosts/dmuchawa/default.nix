{ darwinModules, ... }:
{
  imports = [
    "${darwinModules}/common"
  ];

  # stateVersion: set to the nix-darwin release this machine was FIRST configured with.
  # Do NOT change this on upgrades. See: https://daiderd.com/nix-darwin/manual/index.html
  system.stateVersion = 6;
}
