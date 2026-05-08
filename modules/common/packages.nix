{ pkgs, ... }:
{
  # Packages that will be installed in both NixOS and darwin
  environment.systemPackages = with pkgs; [
    fnm
    poetry
    uv
    ffmpeg
    prettierd
    nodejs_22

    nixos-generators
    sops
    age
    just
    go
  ];
}
