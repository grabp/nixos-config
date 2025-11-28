{ pkgs, ... }: {
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = ["python-2.7.18.8" "electron-25.9.0"];
  };

  environment.systemPackages = with pkgs; [
    # Desktop apps
    discord
    gparted
    vscode
    wezterm
    brave
    xfce.thunar
    xfce.xfce4-pulseaudio-plugin
    networkmanagerapplet
    blueman
    libreoffice-qt
    hunspell
    spotify

    # Development
    # nodejs
    # python
    # ruby
    # libyaml
    gcc
    # gnumake

    # CLI utils
    neovim
    neofetch
    file
    tree
    wget
    git
    fastfetch
    htop
    nix-index
    unzip
    scrot
    mediainfo
    ranger
    zip
    openssl
    swww
    wev
    bluez
    bluez-tools
    chafa
    nil
    nixd

    # GUI utils
    feh
    imv
    dmenu
    screenkey
    gromit-mpx
    pavucontrol

    # Wayland stuff
    xwayland
    wl-clipboard
    cliphist

    # WMs and stuff
    hyprland

    # xdg-desktop-portal-hyprland dependencies just to be sure
    hyprland-protocols
    hyprlang
    hyprutils
    hyprwayland-scanner
    libdrm
    dconf
    sdbus-cpp

    # Screensharing
    xdg-utils
    xdg-desktop-portal-hyprland
    wireplumber
    grim
    slurp

    # Waybar
    waybar
    libappindicator
    libappindicator-gtk3
    libdbusmenu-gtk3
    spdlog

    # Sound
    pipewire
    pulseaudio
    pamixer
    playerctl

    # Screenshotting
    grim
    grimblast
    slurp
    flameshot
    swappy

    # Other
    home-manager
    spice-vdagent
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    hyprland-qt-support
  ];
}
