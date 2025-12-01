{pkgs, ...}: {
  home.packages = with pkgs; [
    zellij
  ];

  xdg.configFile."zellij".source = ./zellij;
}
