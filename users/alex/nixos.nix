{ pkgs, inputs, ... }:
{
  users.users.alex = {
    initialPassword = "alex";
    isNormalUser = true;
    description = "alex";
    extraGroups = [
      "alex"
      "wheel"
      "networkmanager"
    ];

    shell = pkgs.zsh;

    packages = with pkgs; [];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 aaaac3nzac1lzdi1nte5aaaaipwvacwmbdrpk3nypxbxuhknuvoy4ewn2cfgtg3icxek alex@desktop"
    ];
  };
}
