{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      mkSystem = import ./modules/lib/mksystem.nix {
        inherit nixpkgs inputs;
      };
    in
    {
      nixosConfigurations.nixosvirt01 = mkSystem "nixosvirt01" {
        system = "x86_64-linux";
        user   = "alex";
        disko  = true;
      };
      nixosConfigurations.dazhbog = mkSystem "dazhbog" {
        system = "aarch64-linux";
        user   = "alex";
        disko  = true;
      };

      apps.x86_64-linux = {
        test-vm = {
          type = "app";
          program = "${(import ./apps/test-vm { inherit pkgs; })}/bin/test-image";
        };
        default = self.apps.x86_64-linux.test-vm;
      };
    };
}
