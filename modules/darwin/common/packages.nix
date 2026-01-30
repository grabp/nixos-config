{ pkgs, ... }:
{
  imports = [
    ../../common/packages.nix
  ];
  # Packages that will be installed in all NixOS installations
  environment.systemPackages = with pkgs; [
    hidden-bar
    raycast
    stats
    _1password-gui
  ];
}
