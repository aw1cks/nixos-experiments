{ pkgs, inputs, lib, config, ... }:
{
  users.users.alex = {
    initialHashedPassword = "$y$j9T$dpE4nFt27XXwojxPADtOD/$mW1WiZyM/VcEzzUi2Dm8yMyBdS2CygudIk5FbPqdjP4";
    isNormalUser = true;
    description = "alex";
    extraGroups = [
      "alex"
      "wheel"
      "networkmanager"
    ];

    shell = lib.mkIf (config.my.system.type == "desktop") pkgs.zsh;

    packages = with pkgs; [];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPwVACwmbdrPk3nYPxBxuhKnUvOy4eWn2CFgTG3iCXEK alex@desktop"
    ];
  };
}
