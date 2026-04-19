{ pkgs, ... }:
{
  # Smart card daemon — required for Yubikey OpenPGP applet
  services.pcscd.enable = true;

  # Udev rules for Yubikey
  services.udev.packages = with pkgs; [
    yubikey-personalization
    libu2f-host
  ];

  # Install system-level tools
  environment.systemPackages = with pkgs; [
    yubikey-personalization
    yubikey-manager
  ];
}
