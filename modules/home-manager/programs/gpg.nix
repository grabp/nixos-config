{ lib, pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      gnupg
      yubikey-manager
    ]
    ++ lib.optionals (!pkgs.stdenv.isDarwin) [ pinentry-gnome3 ];

  programs.gpg = {
    enable = true;
    settings = {
      keyserver = "hkps://keys.openpgp.org";
      keyserver-options = "auto-key-retrieve";
      use-agent = true;
      trust-model = "tofu+pgp";
    };
    publicKeys = [ ];
  };

  # Linux: gpg-agent managed by systemd
  services.gpg-agent = lib.mkIf (!pkgs.stdenv.isDarwin) {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 600;
    maxCacheTtl = 7200;
    pinentry = {
      package = pkgs.pinentry-gnome3;
    };
    sshKeys = [ "648967E7D2D51663B5F38FDE09AA07CC2CB00A67" ];
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };

  # macOS: manage agent config via home.file (no systemd)
  home.file.".gnupg/gpg-agent.conf" = lib.mkIf pkgs.stdenv.isDarwin {
    text = ''
      enable-ssh-support
      default-cache-ttl 600
      max-cache-ttl 7200
      pinentry-program /opt/homebrew/bin/pinentry-mac
    '';
  };

  home.file.".gnupg/sshcontrol" = lib.mkIf pkgs.stdenv.isDarwin {
    text = ''
      648967E7D2D51663B5F38FDE09AA07CC2CB00A67
    '';
  };

  home.activation.gpgPermissions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    chmod 700 $HOME/.gnupg 2>/dev/null || true
  '';
}
