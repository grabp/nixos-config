{ pkgs, ... }:
let
  verifyScript = pkgs.writeShellScriptBin "verify-yubikey" (
    builtins.readFile ../../../files/scripts/verify-yubikey.sh
  );
  setupScript = pkgs.writeShellScriptBin "setup-yubikey-machine" (
    builtins.readFile ../../../files/scripts/setup-yubikey-machine.sh
  );
in
{
  home.packages = [
    verifyScript
    setupScript
  ];
}
