{ pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  virtualisation.vmVariantWithBootLoader = {
    virtualisation = {
      cores = 4;
      memorySize = 8192;
      graphics = true;
      diskSize = 40960;
      useEFIBoot = true;
      qemu.options = [
        "-device virtio-gpu-pci"
      ];
    };
  };
}
