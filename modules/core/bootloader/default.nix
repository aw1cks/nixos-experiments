{ pkgs, ... }:
{
  imports = [
    ./efi.nix
    ./systemd-boot.nix
  ];

  boot = {
    loader.timeout = 0;

    bootspec.enable = true;

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=0"
      "boot.shell_on_fail"
    ];
    consoleLogLevel = 0;

    initrd = {
      verbose = false;
      systemd.enable = true;
    };

    plymouth = {
      enable = true;
      theme = "rings";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "rings" ];
        })
      ];
    };

    tmp.cleanOnBoot = true;
  };
}
