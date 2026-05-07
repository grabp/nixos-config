{
  description = "NixOS system configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS profiles to optimize settings for different hardware
    hardware.url = "github:nixos/nixos-hardware";

    # https://nix.catppuccin.com/getting-started/flakes/
    catppuccin.url = "github:catppuccin/nix/release-25.11";

    nix-citizen.url = "github:LovingMelody/nix-citizen";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      catppuccin,
      sops-nix,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      users = {
        grabowskip = {
          avatar = ./files/avatar/face.jpg;
          email = "grabowskip@icloud.com";
          fullName = "Patryk Grabowski";
          name = "grabowskip";
          signingKey = "E7BF4CD07ECA63F7!"; # [S] subkey on card; ! forces use of this specific subkey
        };
        work = {
          inherit (users.grabowskip) avatar fullName;
          email = "patryk.grabowski@iqvia.com";
          name = "patryk.grabowski@iqvia.com"; # OS username stays the same
          signingKey = null;
        };
        patrykgrabowski = {
          avatar = ./files/avatar/face.jpg;
          email = "grabowskip@icloud.com";
          fullName = "Patryk Grabowski";
          name = "patrykgrabowski";
          signingKey = "E7BF4CD07ECA63F7!"; # [S] subkey on card; ! forces use of this specific subkey
        };
      };

      helpers = import ./lib/mksystem.nix {
        inherit
          self
          inputs
          outputs
          users
          ;
      };
      inherit (helpers) mkNixosConfiguration mkDarwinConfiguration;
    in
    {
      overlays = import ./overlays { inherit inputs; };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      nixosConfigurations = {
        koksownik = mkNixosConfiguration "koksownik" "grabowskip";
      };

      darwinConfigurations = {
        iqvia-mbp = mkDarwinConfiguration "iqvia-mbp" "work";
        dmuchawa = mkDarwinConfiguration "dmuchawa" "patrykgrabowski";
      };
    };
}
