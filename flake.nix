{
  description = "NixOS system configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # home-manager = {
    #   url = "github:nix-community/home-manager/release-24.05";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    #
    # nixvim = {
    #   url = "github:nix-community/nixvim/nixos-24.05";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    # home-manager,
    ...
  }@inputs :
    # let 
    #   system = "x86_64-linux";
    # in{
    nixosConfigurations.BD-1 = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [ 
        ./nixos/configuration.nix
        # inputs.nixvim.nixosModules.nixvim
      ];
    };

    # homeConfigurations.krystian = home-manager.lib.homeManagerConfiguration {
    #   pkgs = nixpkgs.legacyPackages.${system};
    #   modules = [./home-manager/home.nix];
    # };
    
  };


}
