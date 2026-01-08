{
  imports = [
    # ./waybar.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./fuzzel.nix
    ./mako.nix
    ./hyprpanel.nix
    ./obs-studio.nix
    ./hyprpaper.nix
    ./thunderbird.nix
  ];

  dconf = {
    settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = "gruvbox-dark";
        color-scheme = "prefer-dark";
      };
    };
  };
  gtk = {
    enable = true;
    colorScheme = "dark";
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
}
