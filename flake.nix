{
  description = "NixOS system configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }@inputs :
    let 
      system = "x86_64-linux";
    in{
    nixosConfigurations.BD-1 = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ 
        ./nixos/configuration.nix
      ];
    };

    home-manager.backupFileExtension = "backup";
    homeConfigurations.grabowskip = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [./home-manager/home.nix];
    };
  };
}
