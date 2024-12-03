{ inputs, ... }@flakeContext:
inputs.nixpkgs.lib.nixosSystem {
  modules = [
    (if builtins.pathExists "/mnt/etc/nixos/hardware-configuration.nix"
    then /mnt/etc/nixos/hardware-configuration.nix
    else /etc/nixos/hardware-configuration.nix)

    ./brokolice/system.nix flakeContext
    ./brokolice/packages.nix flakeContext
  ];
  system = "x86_64-linux";
}
