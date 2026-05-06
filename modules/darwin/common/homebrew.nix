{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "uninstall";
    };
    # Apps that must be Apple Developer-signed to satisfy macOS 26 Launch
    # Constraints. Nix-built binaries carry no Team ID and are killed by
    # launchd with EXC_CRASH / Launch Constraint Violation when launched
    # from the app launcher.
    casks = [
      "kitty"
    ];
    brews = [
      "pinentry-mac"
    ];
  };
}
