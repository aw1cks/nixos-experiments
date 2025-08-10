{ lib, inputs, ... }:
{
  options.my.system = {
    type = lib.mkOption {
      type = lib.types.enum [ "desktop" "server" ];
      default = "server";
      description = "The type of system, e.g. desktop or server.";
    };

    isVmBuild = lib.mkOption {
      type = lib.types.bool;
      readOnly = true;
      default = builtins.getEnv "NIX_VM_BUILD" == "1";
      description = "Whether we are in a test VM build where we may need to vary the config compared to the real environment.";
    };
  };
}
