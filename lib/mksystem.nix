{
  self,
  inputs,
  outputs,
  users,
}:
let
  inherit (inputs)
    nixpkgs
    nix-darwin
    home-manager
    catppuccin
    ;
in
{
  mkNixosConfiguration =
    hostname: username:
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs outputs hostname;
        userConfig = users.${username};
        nixosModules = self + /modules/nixos;
      };
      modules = [
        catppuccin.nixosModules.catppuccin
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.extraSpecialArgs = {
            inherit inputs outputs hostname;
            userConfig = users.${username};
            nhModules = self + /modules/home-manager;
          };
          home-manager.users.${username} = import (self + /home/${username}/${hostname});
          home-manager.sharedModules = [
            catppuccin.homeModules.catppuccin
          ];
        }
        (self + /hosts/${hostname})
      ];
    };

  mkDarwinConfiguration =
    hostname: username:
    nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        inherit inputs outputs hostname;
        userConfig = users.${username};
        darwinModules = self + /modules/darwin;
      };
      modules = [
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.extraSpecialArgs = {
            inherit inputs outputs hostname;
            userConfig = users.${username};
            nhModules = self + /modules/home-manager;
          };
          home-manager.users.${username} = import (self + /home/${username}/${hostname});
          home-manager.sharedModules = [
            catppuccin.homeModules.catppuccin
          ];
        }
        (self + /hosts/${hostname})
      ];
    };
}
