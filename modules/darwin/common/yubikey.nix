{ pkgs, ... }:
{
  # macOS has its own CryptoTokenKit — no pcscd needed.
  # Install ykman and gnupg system-wide.
  environment.systemPackages = with pkgs; [
    yubikey-manager
    gnupg
  ];
}
