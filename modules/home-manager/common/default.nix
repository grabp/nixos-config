{
  outputs,
  userConfig,
  pkgs,
  ...
}:
{
  imports = [
    ../programs
    ../misc/copy-files-to-dotconfig
  ];

  catppuccin = {
    enable = true;
    accent = "peach";
    flavor = "mocha";

    nvim = {
      enable = false;
    };
  };

  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Home-Manager configuration for the user's home environment
  home = {
    username = "${userConfig.name}";
    homeDirectory =
      if pkgs.stdenv.isDarwin then "/Users/${userConfig.name}" else "/home/${userConfig.name}";
  };

  # Ensure common packages are installed
  home.packages =
    with pkgs;
    [
      chafa
      fastfetch
      dig
      dust
      eza
      fd
      jq
      kubectl
      nh
      openconnect
      pipenv
      podman-compose
      podman-tui
      python3
      ripgrep
      terraform
      zip
      fastfetch
      wget
      git
      nix-index
      unzip
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      hidden-bar
      raycast
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      unzip
      wl-clipboard
    ];
}
