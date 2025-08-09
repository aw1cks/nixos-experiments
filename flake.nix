{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      ...
    }@inputs:
    let
      mkSystem = import ./modules/lib/mksystem.nix {
        inherit nixpkgs inputs;
      };
    in
    {
      nixosConfigurations.nixosvirt01 = mkSystem "nixosvirt01" {
        system = "x86_64-linux";
        user   = "alex";
      };
      nixosConfigurations.dazhbog = mkSystem "dazhbog" {
        system = "aarch64-linux";
        user   = "alex";
        disko  = true;
      };
    };
}
