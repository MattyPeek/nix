{ inputs, ... }@flakeContext:
inputs.nix-darwin.lib.darwinSystem {
  modules = [
    ./brokolice/hardware.nix
    #/mnt/etc/nixos/hardware-configuration.nix
    
    #(if builtins.pathExists "/mnt/etc/nixos/hardware-configuration.nix"
    #then /mnt/etc/nixos/hardware-configuration.nix
    #else /etc/nixos/hardware-configuration.nix)

    ./brokolice/system.nix
    ./brokolice/packages.nix
  ];
  system = "x86_64-linux";
}
