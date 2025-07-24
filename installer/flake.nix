{
  description = "NixOS installer";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default = self.nixosConfigurations.bootIso.config.system.build.isoImage;

    nixosConfigurations = {
      bootIso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, modulesPath, ... }: {
            imports = [
              (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
              (modulesPath + "/installer/cd-dvd/channel.nix")
            ];

            i18n.supportedLocales = [
              "en_US.UTF-8/UTF-8"
              "en_GB.UTF-8/UTF-8"
              "pl_PL.UTF-8/UTF-8"
              "de_DE.UTF-8/UTF-8"
              "fr_FR.UTF-8/UTF-8"
              "ru_RU.UTF-8/UTF-8"
            ];
            i18n.defaultLocale = "en_US.UTF-8";

            security.sudo.wheelNeedsPassword = false;

            users.users.alex = {
              initialPassword = "Super!S3cure";
              isNormalUser = true;
              description = "alex";
              extraGroups = [
                "alex"
                "wheel"
              ];

              shell = pkgs.zsh;

              packages = with pkgs; [];

              openssh.authorizedKeys.keys = [
                "ssh-ed25519 aaaac3nzac1lzdi1nte5aaaaipwvacwmbdrpk3nypxbxuhknuvoy4ewn2cfgtg3icxek alex@desktop"
              ];
            };

            environment.systemPackages = with pkgs; [
              git
              rsync
              zsh
              neovim
              wget
              curl
              lshw
            ];

            programs.zsh.enable = true;
            services.openssh.enable = true;

            system.stateVersion = "25.05";
          })
        ];
      };
    };
  };
}
