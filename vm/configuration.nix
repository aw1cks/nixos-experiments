{ config, lib, pkgs, ... }:
{
  imports = [
    ./disk-config.nix
  ];

  nix.settings.trusted-users = [ "root" "alex" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixosvirt01";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
    "pl_PL.UTF-8/UTF-8"
    "de_DE.UTF-8/UTF-8"
    "fr_FR.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "en_US.UTF-8";

  users.mutableUsers = false;
  security.sudo.wheelNeedsPassword = false;

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

  environment.systemPackages = with pkgs; [
    git
    rsync
    zsh
    neovim
    wget
    curl
    lshw
    htop

    kitty
  ];

  programs.zsh.enable = true;
  # Make sure we don't get nagged to configure zsh
  system.userActivationScripts.zshrc = "touch .zshrc";


  services.openssh.enable = true;

  services.displayManager.ly = {
    enable = true;
    settings = {
      load = true;
      save = true;
      clear_password = true;
      shutdown_cmd = "/run/current-system/sw/bin/systemctl poweroff";
      restart_cmd = "/run/current-system/sw/bin/systemctl reboot";
    };
  };
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  virtualisation.vmVariantWithBootLoader = {
    virtualisation = {
      cores = 4;
      memorySize = 8192;
      graphics = true;
      diskSize = 8192;
      useEFIBoot = true;
      qemu.options = [
        # Better graphics performance
        "-vga qxl"
      ];
    };
  };

  system.stateVersion = "25.05";
}
