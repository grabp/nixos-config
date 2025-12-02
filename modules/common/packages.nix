{ pkgs, ... }:
{
  # Packages that will be installed in both NixOS and darwin
  environment.systemPackages = with pkgs; [
    fnm
    poetry
    uv
    ffmpeg
    starship
    prettierd
    nodejs_22
  ];
}
