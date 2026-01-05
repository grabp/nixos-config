{ inputs, config, hostname, pkgs,
  nixosModules, ... }:

{
  imports =
    [
      inputs.hardware.nixosModules.common-cpu-amd
      inputs.hardware.nixosModules.common-gpu-amd
      inputs.hardware.nixosModules.common-pc-ssd
      
      ./hardware-configuration.nix
      "${nixosModules}/common"
      "${nixosModules}/desktop"
      "${nixosModules}/programs"
    ];

  boot.initrd.luks.devices."luks-7d7b6fbb-f87b-454a-a613-74e38b810ae9".device = "/dev/disk/by-uuid/7d7b6fbb-f87b-454a-a613-74e38b810ae9";

  networking.hostName = hostname;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
