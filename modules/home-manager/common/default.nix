{
  userConfig,
  pkgs,
  lib,
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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Home-Manager configuration for the user's home environment
  home = {
    username = "${userConfig.name}";
    homeDirectory =
      if pkgs.stdenv.isDarwin then "/Users/${userConfig.name}" else "/home/${userConfig.name}";
    # Fix for Python testing.postgresql: ensure real Nix store PostgreSQL
    # path comes before home-manager symlinks, so `which initdb` returns
    # the real path and initdb can find its data files (postgres.bki)
    sessionPath = [ "${pkgs.postgresql_15}/bin" ];
    sessionVariables = {
      PGSHAREDIR = "${pkgs.postgresql_15}/share/postgresql";
    };
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
      fnm
      pre-commit
      sqlite
      terraform
      redis
      postgresql_15
      tree-sitter
      imagemagick
      mermaid-cli
      ghostscript
      ast-grep
      gh
      unstable.opencode
      bun
      unstable.claude-code
    ]
    ++ lib.optionals stdenv.isDarwin [
      # hidden-bar
      # raycast
      # stats
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      unzip
      wl-clipboard
      ueberzug
    ];

  systemd.user.sockets.podman = lib.mkIf (!pkgs.stdenv.isDarwin) {
    Unit.Description = "Podman API Socket";
    Socket = {
      ListenStream = "%t/podman/podman.sock";
      SocketMode = "0660";
    };
    Install.WantedBy = [ "sockets.target" ];
  };

  systemd.user.services.podman = lib.mkIf (!pkgs.stdenv.isDarwin) {
    Unit = {
      Description = "Podman API Service";
      Requires = [ "podman.socket" ];
    };
    Service = {
      ExecStart = "${pkgs.podman}/bin/podman system service";
      TimeoutStopSec = 30;
    };
  };
}
