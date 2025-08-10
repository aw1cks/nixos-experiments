BUILD_MEM_MB := "16384"

export TESTVM_NUM_CORES := env("TESTVM_NUM_CORES", "8")
export TESTVM_MEM_MB    := env("TESTVM_MEM_MB", "16384")

DISK := env("DISK_IMAGE", "disko.raw")

installSsh machine sshAddr:
  nix run github:nix-community/nixos-anywhere -- \
      --build-on auto \
      --flake '.#{{machine}}' \
      --target-host '{{sshAddr}}'

testvm machine:
    #!/bin/bash
    set -euo pipefail
    rm -vf '{{DISK}}'
    printf '{{YELLOW}}{{BOLD}}Building VM{{NORMAL}}\n'
    NIX_VM_BUILD=1 nix build '.#nixosConfigurations.{{machine}}.config.system.build.diskoImagesScript'
    ./result --build-memory '{{BUILD_MEM_MB}}'
    printf '{{CYAN}}{{BOLD}}Running VM{{NORMAL}}\n'
    export ARCH="$(nix eval --no-warn-dirty --raw .#nixosConfigurations.{{machine}}.pkgs.system)"
    export MACHINE_TYPE="$(nix eval --no-warn-dirty --raw .#nixosConfigurations.nixosvirt01.config.my.system.type)"
    nix run --no-warn-dirty .#test-vm -- '{{DISK}}'

sshvm:
  ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no alex@localhost -p 2222

clean:
  rm -vf ./*.raw ./*.qcow2 ./*-efi-vars.fd ./result*
  nix gc
