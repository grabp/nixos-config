{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awscli
    saml2aws
  ];
}
