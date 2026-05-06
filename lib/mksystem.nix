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
    let
      user = users.${username};
    in
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs outputs hostname;
        userConfig = user;
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
            userConfig = user;
            nhModules = self + /modules/home-manager;
          };
          # Use the OS username as the HM attribute key so nix-darwin/nixos can
          # infer homeDirectory from the system user entry.
          home-manager.users.${user.name} = import (self + /home/${username}/${hostname});
          home-manager.sharedModules = [
            catppuccin.homeModules.catppuccin
          ];
        }
        (self + /hosts/${hostname})
      ];
    };

  mkDarwinConfiguration =
    hostname: username:
    let
      user = users.${username};
    in
    nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {
        inherit inputs outputs hostname;
        userConfig = user;
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
            userConfig = user;
            nhModules = self + /modules/home-manager;
          };
          # Use the OS username as the HM attribute key so nix-darwin/nixos can
          # infer homeDirectory from the system user entry.
          home-manager.users.${user.name} = import (self + /home/${username}/${hostname});
          home-manager.sharedModules = [
            catppuccin.homeModules.catppuccin
          ];
        }
        (self + /hosts/${hostname})
      ];
    };
}
