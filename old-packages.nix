{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [

    # CLI utils
    neovim
    fastfetch
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
  ];
}
