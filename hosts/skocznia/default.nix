{
  inputs,
  hostname,
  nixosModules,
  pkgs,
  ...
}:
{
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
    "${nixosModules}/common"
    "${nixosModules}/desktop"
    "${nixosModules}/programs"
  ];

  # Additional required graphics settings
  hardware.nvidia.open = true;

  # Enable vulkan for 32-bit applications
  hardware.graphics.enable32Bit = true;

  # Optionally, specify Mesa package version if needed (newer versions for NVK driver)
  hardware.opengl.package = pkgs.mesa.drivers;
  hardware.opengl.enable = true;

  # Set hostname
  networking.hostName = hostname;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "25.11";
}
