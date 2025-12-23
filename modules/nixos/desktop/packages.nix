{ pkgs, ... }:
{
  # List of Hyprland specific packages
  environment.systemPackages = with pkgs; [
    loupe # image viewer
    nautilus # file manager
    seahorse # keyring manager
    totem # Video player

    # Desktop apps
    discord
    gparted
    vscode
    wezterm
    brave
    xfce.thunar
    xfce.xfce4-pulseaudio-plugin
    libreoffice-qt
    hunspell
    spotify

    # GUI utils
    feh
    imv
    dmenu
    screenkey
    gromit-mpx
    pavucontrol
    bambu-studio

    # Wayland stuff
    xwayland
    wl-clipboard
    cliphist

    # Hyprland
    hypridle
    hyprlock
    hyprpaper
    hyprpicker
    hyprland-protocols
    hyprwayland-scanner
    hyprlang
    hyprutils

    brightnessctl
    libnotify
    networkmanagerapplet
    pamixer
    pavucontrol
    slurp
    wf-recorder
    wlr-randr
    wlsunset

    # Screenshot stuff
    grim
    grimblast
    swappy

    # Waybar
    waybar
    libappindicator
    libappindicator-gtk3
    libdbusmenu-gtk3
    spdlog

    # Sound
    pamixer
    playerctl

    # xdg-desktop-portal-hyprland dependencies just to be sure
    libdrm
    dconf
    sdbus-cpp

    # Enables v4l2loopback GUI utilities.
    v4l-utils

    # Screensharing
    xdg-utils
    xdg-desktop-portal-hyprland
    wireplumber
    slurp

    # Other
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    hyprland-qt-support
    gamemode
    unzip
    cabextract
    zenity
  ];
}
