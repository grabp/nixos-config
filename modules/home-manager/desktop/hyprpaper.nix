{ lib, ... }:
{
  services.hyprpaper = {
    enable = true;

    settings = {
      preload = lib.mkDefault [ "~/.config/wallpapers/default.jpg" ];
      wallpaper = lib.mkDefault [ ];
    };
  };
}
