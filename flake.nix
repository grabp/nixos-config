{
  description = "NixOS system configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

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
    catppuccin.url = "github:catppuccin/nix/release-25.05";

    nix-citizen.url = "github:LovingMelody/nix-citizen";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      catppuccin,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      # User configuration
      users = {
        grabowskip = {
          avatar = ./files/avatar/face.jpg;
          email = "grabowskip@icloud.com";
          fullName = "Patryk Grabowski";
          name = "grabowskip";
          signingKey = "E7BF4CD07ECA63F7!"; # [S] subkey on card; ! forces use of this specific subkey
        };
        "patryk.grabowski@iqvia.com" = {
          inherit (users.grabowskip)
            avatar
            fullName
            ;
          email = "patryk.grabowski@iqvia.com";
          name = "patryk.grabowski@iqvia.com";
          signingKey = null;
        };
      };

      # Function for NixOS system configuration
      mkNixosConfiguration =
        hostname: username:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs hostname;
            userConfig = users.${username};
            nixosModules = "${self}/modules/nixos";
          };
          modules = [
            catppuccin.nixosModules.catppuccin
            ./hosts/${hostname}
          ];
        };
      # Function for nix-darwin system configuration
      mkDarwinConfiguration =
        hostname: username:
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs outputs hostname;
            userConfig = users.${username};
            darwinModules = "${self}/modules/darwin";
          };
          modules = [
            ./hosts/${hostname}
          ];
        };

      # Function for Home Manager configuration (linux)
      mkHomeConfiguration =
        system: username: hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          extraSpecialArgs = {
            inherit inputs outputs hostname;
            userConfig = users.${username};
            nhModules = "${self}/modules/home-manager";
          };
          modules = [
            ./home/${username}/${hostname}
            catppuccin.homeModules.catppuccin
          ];
        };

      # Function for Home Manager configuration (linux)
      mkDarwinHomeConfiguration =
        system: username: hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          extraSpecialArgs = {
            inherit inputs outputs hostname;
            userConfig = users.${username};
            nhModules = "${self}/modules/home-manager";
          };
          modules = [
            ./home/${username}/${hostname}
            catppuccin.homeModules.catppuccin
          ];
        };
    in
    {
      nixosConfigurations = {
        koksownik = mkNixosConfiguration "koksownik" "grabowskip";
      };

      darwinConfigurations = {
        ZTDMWCFP3J5YY = mkDarwinConfiguration "ZTDMWCFP3J5YY" "patryk.grabowski@iqvia.com";
      };

      homeConfigurations = {
        "grabowskip@koksownik" = mkHomeConfiguration "x86_64-linux" "grabowskip" "koksownik";
        "patryk.grabowski@iqvia.com@ZTDMWCFP3J5YY" =
          mkDarwinHomeConfiguration "aarch64-darwin" "patryk.grabowski@iqvia.com"
            "ZTDMWCFP3J5YY";
      };
    };
}
