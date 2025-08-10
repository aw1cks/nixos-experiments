{ pkgs, ... }:

let
  pkgsAarch64 = pkgs.pkgsCross.aarch64-multiplatform;

  # Method 1: Read Python script from file in same directory
  pythonScript = builtins.readFile ./launch.py;

  # Method 2: Alternative - use pkgs.writeText to create a separate derivation
  # pythonScriptFile = pkgs.writeText "test-image.py" (builtins.readFile ./test-image.py);
in
pkgs.writeShellApplication {
  name = "test-image";
  runtimeInputs = [ pkgs.python3 pkgs.qemu pkgs.file ];
  text = ''
    export NIXPKG_AARCH64_OVMF__FD="${pkgsAarch64.OVMF.fd}"
    export NIXPKG_X86_64_OVMF__FIRMWARE="${pkgs.OVMF.firmware}"
    export NIXPKG_X86_64_OVMF__VARIABLES="${pkgs.OVMF.variables}"
    python3 -c '${pythonScript}' "$@"
  '';
}