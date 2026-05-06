{ ... }:
{
  sops = {
    defaultSopsFile = ../../../secrets/koksownik.yaml;
    age.keyFile = "/var/lib/sops-nix/keys.txt";

    secrets.smb_credentials = { };
  };
}
