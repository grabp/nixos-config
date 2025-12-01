{ pkgs, inputs, ... }:
{
  # # Nixpkgs configuration
  # nixpkgs = {
  #   overlays = [
  #     inputs.brew-nix.overlays.default
  #   ];
  #
  #   config = {
  #     allowUnfree = true;
  #   };
  # };
  #
  # # Brew packages
  # home.packages = with pkgs; [
  #   brewCasks.hiddenbar
  #   brewCasks.raycast
  #   brewCasks.stats
  # ];
  targets.darwin.copyApps = {
    enable = true;
  };
}
