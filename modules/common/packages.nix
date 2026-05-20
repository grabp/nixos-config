{ pkgs, ... }:
{
  # Packages that will be installed in both NixOS and darwin
  environment.systemPackages = with pkgs; [
    fnm
    poetry
    unstable.uv
    ruff
    ffmpeg
    prettierd
    nodejs_22
    wireguard-tools

    nixos-generators
    sops
    age
    just
    go
  ];
}
