{ lib, ... }:
{
  options.my.system.type = lib.mkOption {
    type = lib.types.enum [ "desktop" "server" ];
    default = "server";
    description = "The type of system, e.g. desktop or server.";
  };
}
