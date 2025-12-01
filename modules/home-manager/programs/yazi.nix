{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    extraPackages = with pkgs; [
      glow
      ouch
    ];
  };
}
