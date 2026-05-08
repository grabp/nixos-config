{ pkgs, ... }:
let
  zellijForgot = pkgs.fetchurl {
    url = "https://github.com/karimould/zellij-forgot/releases/download/0.4.2/zellij_forgot.wasm";
    hash = "sha256-MRlBRVGdvcEoaFtFb5cDdDePoZ/J2nQvvkoyG6zkSds=";
  };
  zellijConfig = pkgs.runCommand "zellij-config" { } ''
    mkdir -p $out/plugins
    cp -r ${./zellij}/. $out/
    cp ${zellijForgot} $out/plugins/zellij-forgot.wasm
  '';
in
{
  home.packages = with pkgs; [
    zellij
  ];

  xdg.configFile."zellij".source = zellijConfig;
}
