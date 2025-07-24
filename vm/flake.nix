{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      disko,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.nixosvirt01 = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit pkgs;
        modules = [
          disko.nixosModules.disko
          ./configuration.nix
        ];
      };
      formatter.${system} = pkgs.nixfmt-tree;
    };
}
