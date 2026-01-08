{ pkgs, ... }:
{
  imports = [
    ./audio.nix
    ./packages.nix
  ];
  # Enable GDM display manager
  # services.displayManager.gdm.enable = true;

  # Call dbus-update-activation-environment on login
  services.xserver.updateDbusEnvironment = true;

  # Enable Bluetooth support
  services.blueman.enable = true;

  ## Hyprland
  # Install hyperland
  programs.hyprland = {
    enable = true;
  };
  # Install hyprlock
  programs.hyprlock.enable = true;
  # Install hypridle
  services.hypridle.enable = true;

  # Turn on pam security services for hyprlock
  security = {
    polkit.enable = true;
    pam.services.hyprlock = { };
  };

  services.flatpak.enable = true;
  programs.adb.enable = true;

  environment.variables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    # XDG_DATA_HOME = "$HOME/.local/share:/root/.local/share:/usr/local/share/:/usr/share/";
    # XDG_DATA_DIRS = "$HOME/.local/share:/root/.local/share:/usr/local/share/:/usr/share/";
  };
}
