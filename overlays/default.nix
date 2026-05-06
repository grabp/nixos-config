{ inputs, ... }:
{
  # Expose stable and unstable channels as pkgs.stable.* and pkgs.unstable.*
  extra-channels = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
